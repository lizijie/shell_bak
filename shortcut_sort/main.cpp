#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

#define ROW_MAX_SIZE 9999

int main(int argc, char *argv[])
{
    FILE *fr = fopen("input", "r");
    if (fr == NULL) 
    {
        perror("fopen fail\n");
        return -1;
    }

    char *pRows[ROW_MAX_SIZE];
    int iRowSz = 0;

    char pBuf[512];
    char iBufSz;
    int c = 0;
    do
    {
        c = fgetc(fr);
        pBuf[iBufSz] = tolower(c);
        ++iBufSz;

       if (c == '\n')
        {
            pBuf[iBufSz] = '\0'; 
            ++iBufSz;

            char *newStr = strdup(pBuf);
            pRows[iRowSz] = newStr;
            ++iRowSz;

            iBufSz = 0;
        }

    } while (c != EOF);
    fclose(fr);
    fr = NULL;

    // todo: 去重,冲突合并
    
    char *l = NULL;
    char* r = NULL;
    char* tmp = NULL;
    int v = 0;
    for (int i = 0; i < iRowSz - 1; ++i) 
    {
        for (int j = 0; j < iRowSz - 1 - i; ++j) 
        {
            l = pRows[j];
            r = pRows[j+1];
            v = strcmp(l, r);
            if (v > 0) 
            {
                tmp = l;
                pRows[j] = r;
                pRows[j+1] = tmp;
            }
        }
    }

    // 输出文件
    FILE* fw = fopen("output", "w+");
    if (fw == NULL)
    {
        perror("fopen fail\n");
        return -1;
    }
    int sn = 0;
    char* pS = NULL;
    for (int i = 0; i < iRowSz; ++i)
    {
        pS = pRows[i];
        sn = strlen(pS);
        fwrite(pS, 1, sn, fw);
    }
    fclose(fw);
    fw = NULL;

    for (int i = 0; i < iRowSz; ++i)
    {
        printf("%s", pRows[i]);
        free(pRows[i]);
        pRows[i] = NULL;
    }
    return 0;
}