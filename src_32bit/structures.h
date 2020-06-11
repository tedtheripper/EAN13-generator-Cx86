//
// Created by tedtheripper on 5/15/20.
//

#ifndef PROJ2_X86_STRUCTURES_H
#define PROJ2_X86_STRUCTURES_H
typedef uint32_t color_t;
typedef struct{
    unsigned short Preamble;
    unsigned long FileSize;
    unsigned long Reserved1;
    unsigned long DataOffset;
    unsigned long InfoLength;
    long Width;
    long Height;
    short Planes;
    short Bpp;
    unsigned long Compression;
    unsigned long ImageSize;
    unsigned long Xppm;
    unsigned long Yppm;
    unsigned long ColorsUsed;
    unsigned long ColorsNeeded;
    color_t Color1;
    color_t Color2;
}__attribute__((packed)) BitmapHeader;

typedef struct{
    BitmapHeader* HeaderPtr;
    unsigned long FileSize;
    unsigned char* DataPtr;
    unsigned long Width;
    unsigned long Height;
    unsigned long RowSize;
    unsigned short StripeSize;
}__attribute__((packed)) BitmapDescriptor;


#endif //PROJ2_X86_STRUCTURES_H
