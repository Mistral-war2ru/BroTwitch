#include <Windows.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "patch.h"

#define NOT_FOUND -1

int strpos(const char* haystack, const char* needle)
{
    const char* p = strstr(haystack, needle);
    if (p)
        return p - haystack;
    return NOT_FOUND;
}

void work(char* msg)
{
    int pos1 = strpos(msg, "<div class=\"text\">");
    int pos2 = strpos(msg, "</div></div>");
    if ((pos1 != NOT_FOUND) && (pos2 != NOT_FOUND) && (pos1 < pos2))
    {
        pos1 += 18;
        char buf[1024];
        for (int i = pos1; i < pos2; i++)
        {
            buf[i - pos1] = msg[i];
        }
        buf[pos2 - pos1] = 0;
        int pos3 = strpos(buf, "Twitch File: twitch/");
        if (pos3 != NOT_FOUND)
        {
            pos3 += 20;
            char buf2[MAX_PATH];
            int lng = strlen(buf);
            for (int i = pos3; i < lng; i++)
            {
                buf2[i - pos3] = buf[i];
            }
            buf2[lng - pos3] = 0;
            char file[1024];
            sprintf(file, "../data/twitch/%s", buf2);
            remove(file);
            //MessageBox(NULL, buf2, "", MB_OK);
        }
        pos3 = strpos(buf, "Twitch Day: ");
        if (pos3 != NOT_FOUND)
        {
            pos3 += 12;
            char buf2[MAX_PATH];
            int lng = strlen(buf);
            for (int i = pos3; i < lng; i++)
            {
                buf2[i - pos3] = buf[i];
            }
            buf2[lng - pos3] = 0;
            char file[1024];
            sprintf(file, "../data/twitch/!day %s", buf2);

            FILE* fp;
            if ((fp = fopen(file, "wb")) != NULL)//file opened
            fclose(fp);

            //MessageBox(NULL, file, "", MB_OK);
        }
    }
    //<div class = "text">test file : twitch/TEST_blueprint</div></div>
}

PROC g_proc_print;
void __stdcall print_call(char* msg, int size)
{
    ((int __stdcall (*)(char*, int))g_proc_print)(msg, size);//original
    work(msg);
}

void hook(int adr, PROC* p, char* func)
{
    *p = patch_call((char*)adr, func);
}

extern "C" __declspec(dllexport) void edo()
{
    char snp[] = "BattleBrothers.exe";
    int ad = (int)GetModuleHandleA(snp);
    if (ad != 0)
    {
		//1.5.0.12 (15)
        ad += 0x120A63;//gog version
		//ad += 0x1238F3;//steam version
        hook(ad, &g_proc_print, (char*)print_call);
    }
    //exe+120A63
}

BOOL WINAPI DllMain(HINSTANCE hinstDLL, DWORD ul_reason_for_call, LPVOID) 
{
    if (ul_reason_for_call == DLL_PROCESS_ATTACH)edo();
    //if (ul_reason_for_call == DLL_PROCESS_ATTACH)MessageBox(NULL, "test", "", MB_OK);
    return TRUE; 
}