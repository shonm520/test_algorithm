#include <stdio.h>
#include <string>
#include <string.h>
using std::string;

typedef unsigned int uint;

struct ITEM
{
	string key;
	void* data;
	ITEM* pPrev;
	ITEM* pNext;
};


class StrHashMap  {
public:
	StrHashMap(int nSize = 83);
	~StrHashMap();

	void resize(int nSize = 83);
	void* find(const char* key, bool optimize = true) const;
	bool insert(const char* key, void* data);
	void* set(const char* key, void* data);
	bool remove(const char* key);
	void remove_all();
	int get_size();

protected:
	ITEM** m_aT;
	int m_nBuckets;
	int m_nCount;

};

unsigned int hashkey(const char* key)  {
	uint i = 0;
	uint len = strlen(key);
	while(len-- > 0)  {
		i = (i << 5) + i + key[len];
	}
	return i;
}


StrHashMap::StrHashMap(int nSize)   {
	if (nSize < 16) nSize = 16;
	m_nBuckets = nSize;
	m_aT = new ITEM*[nSize];
	memset(m_aT, 0, nSize * sizeof(ITEM*));
}

StrHashMap::~StrHashMap()  {

}

void* StrHashMap::find(const char* key, bool optimize) const  {
	if (m_nBuckets == 0) return NULL;

	uint slot = hashkey(key) % m_nBuckets;
	for (ITEM* pItem = m_aT[slot]; pItem; pItem = pItem->pNext)  {
		if (pItem->key == key)  {
			if (optimize && pItem != m_aT[slot])  {         //如果找到的不是链表中的第一个,则将找到的元素成为头结点，类似LRU算法
				if (pItem->pNext)  {                        //1)步骤1)是将找到的元素断开
					pItem->pNext->pPrev = pItem->pPrev;     //1)
				}
				pItem->pPrev->pNext = pItem->pNext;         //1)
				pItem->pPrev = NULL;                        //2)步骤2)是将找到的元素的next指向头结点
				pItem->pNext = m_aT[slot];                  //2)
				pItem->pNext->pPrev = pItem;                //2)
				m_aT[slot] = pItem;                         //3)步骤3)是让找到的元素成为头结点
			}
			return pItem->data;
		}
	}
	return NULL;
}

bool StrHashMap::insert(const char* key, void* pData)  {
	if (m_nBuckets == 0) return false;
	if (find(key)) return false;

	uint slot = hashkey(key) % m_nBuckets;
	ITEM* pItem = new ITEM();
	pItem->key = key;
	pItem->data = pData;
	pItem->pPrev = NULL;
	pItem->pNext = m_aT[slot];
	if (pItem->pNext)  {
		pItem->pNext->pPrev = pItem;
	}
	m_aT[slot] = pItem;     //new item in the head of the list
	m_nCount++;
	return true;
}

bool StrHashMap::remove(const char* key)  {
	if (m_nBuckets == 0) return false;

	uint slot = hashkey(key) % m_nBuckets;
	ITEM** ppItem = &m_aT[slot];
	while(*ppItem)  {
		if ((*ppItem)->key == key)  {
			ITEM* pKill = *ppItem;
			*ppItem = (*ppItem)->pNext;
			if (*ppItem)  {
				(*ppItem)->pPrev = pKill->pPrev;
			}
			delete pKill;
			m_nCount--;
			return true;
		}
		ppItem = &((*ppItem)->pNext);
	}
	return false;
}

void StrHashMap::remove_all()  {
	if (m_aT)  {
		int len = m_nBuckets;
		while(len--)  {
			ITEM* pItem = m_aT[len];
			while(pItem)  {
				ITEM* pKill = pItem;
				pItem = pItem->pNext;
				delete pKill;
			}
		}
		delete [] m_aT;
		m_aT = NULL;
	}
}

int main() {
	StrHashMap strMap;
	strMap.insert("123", (void*)0);
	long data = (long)(strMap.find("123"));
	printf("data is %d\n", data);
	return 0;
}
