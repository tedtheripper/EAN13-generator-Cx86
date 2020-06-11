//
// Created by tedtheripper on 5/15/20.
//

#ifndef PROJ2_X86_STRUCTURES_H
#define PROJ2_X86_STRUCTURES_H
typedef uint32_t color_t;
typedef struct{
    unsigned short Preamble;
    uint32_t FileSize;
    uint32_t Reserved1;
    uint32_t DataOffset;
    uint32_t InfoLength;
    uint32_t Width;
    uint32_t Height;
    short Planes;
    short Bpp;
    uint32_t Compression;
    uint32_t ImageSize;
    uint32_t Xppm;
    uint32_t Yppm;
    uint32_t ColorsUsed;
    uint32_t ColorsNeeded;
    color_t Color1;
    color_t Color2;
}__attribute__((packed)) BitmapHeader;

typedef struct{
    BitmapHeader* HeaderPtr;
    uint32_t FileSize;
    unsigned char* DataPtr;
    uint32_t Width;
    uint32_t Height;
    uint32_t RowSize;
    unsigned short StripeSize;
}__attribute__((packed)) BitmapDescriptor;


#endif //PROJ2_X86_STRUCTURES_H
