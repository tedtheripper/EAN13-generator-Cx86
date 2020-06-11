//Marcel Jarosz, ARKO 2020L, C, Final version
//EAN-13 Barcode Generator
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <memory.h>
#include <stdint.h>
#include "structures.h"

typedef uint8_t byte_t;
const int numberOfStripes = 97;
uint32_t rowBytes(uint32_t b){
    return ((b + 31u) >> 5u) << 2u; //from wikipedia
}
uint32_t dwordAlign(uint32_t d){
    return (d + 3u) & 0xFFFFFFFCu; //from wikipedia
}
BitmapDescriptor* InitImage(int w, int h, int stripeSize){
    BitmapDescriptor *Img = calloc(1, sizeof(BitmapDescriptor));
    Img->Width = w;
    Img->Height = h;
    Img->RowSize = dwordAlign(rowBytes(w));
    Img->FileSize = 62 + Img->RowSize*h;
    //Img->DataPtr = (unsigned char *) calloc(1, Img->FileSize);
    Img->StripeSize = stripeSize;
    byte_t* d = calloc(1, Img->FileSize);
    memset(d, 1, Img->FileSize);
    BitmapHeader* header = (BitmapHeader*) d;
    header->FileSize = Img->FileSize;
    header->Preamble = 0x4D42;
    header->Reserved1 = 0;
    header->DataOffset = 62;
    header->InfoLength = 40;
    header->Width = Img->Width;
    header->Height = Img->Height;
    header->Planes = 1;
    header->Bpp = 1;
    header->Compression = 0;
    header->ImageSize = Img->Height*Img->RowSize;
    header->Xppm = header->Yppm = 0;
    header->ColorsUsed = header->ColorsNeeded = 0;
    header->Color1 = 0x00000000;
    header->Color2 = 0x00FFFFFF;
    Img->HeaderPtr = header;
    Img->DataPtr = (byte_t*)header + 62;
    return Img;
}
extern char* get_encoding(char* code);
extern char* create_bin_data(char* code, char* chosen_encoding);
int min(int a, int b) { return a > b ? b : a;}
char* addChar(const char* s1, const char c){
    char* result = malloc(strlen(s1) + 2);
    strcpy(result, s1);
    strncat(result, &c, 1);
    return result;
}
char* concat(const char* s1, const char* s2){
    char* result = malloc(strlen(s1) + strlen(s2) + 1);
    strcpy(result, s1);
    strcat(result, s2);
    return result;
}
char* getControlDigit(char* code){
    int sum = 0;
    int cntrlD;
    for(int i = 0; i < 12; i++){
        if(i%2 == 0){
            sum += ((int)*(code+i)-48);
        }else{
            sum += (((int)*(code+i)-48)*3);
        }
    }
    cntrlD = (sum%10);
    cntrlD = 10 - cntrlD;
    if(cntrlD == 10){
        cntrlD = 0;
    }
    char d = (char)(cntrlD+48);
    //printf("%c", d);
    //printf("\n");
    //strncat(code, &d, 1);
    char* ctp = addChar(code, d);
    return ctp;

}
char* generateCharCode(char* code){
    char* chosen_encoding;
    char* new_code = getControlDigit(code);
    //printf("%s", new_code);
    //printf("\n");
    chosen_encoding = get_encoding(new_code);
    char* result = create_bin_data(new_code, chosen_encoding);
    return result;
}
byte_t buf[256];
byte_t lookup[] = {0b00000000, 0b00000001, 0b00000011, 0b00000111, 0b00001111, 0b00011111, 0b00111111, 0b01111111, 0b11111111};
void writeBytes(int color, int width, byte_t** pPos, uint8_t* pBitsLeft){
    uint8_t bitsLeft = *pBitsLeft;
    byte_t* pos = *pPos;
    byte_t byte = *pos;
    while(width){
        uint8_t toWrite = min(min(bitsLeft, width), 8);
        byte <<= toWrite;
        byte |= lookup[toWrite*color];
        *pos = byte;
        bitsLeft -= toWrite;
        width -= toWrite;
        if (!bitsLeft){
            bitsLeft = 8;
            byte = *++pos;
        }
    }
    *pPos = pos;
    *pBitsLeft = bitsLeft;
}
void endWriting(byte_t** pPos, uint8_t* pBitsLeft){
    //shift left by the amount of unwritten bits
    if(*pBitsLeft != 8){
        byte_t* pos = *pPos;
        byte_t byte = *pos;
        byte <<= *pBitsLeft;
        byte |= 0b11111111;
        *pos = byte;
    }
}
void printBits(byte_t v){
    byte_t i, s = s = 1u << ((sizeof(v) << 3) - 1);
    for (i = s; i; i >>= 1u) printf("%c", (v & i ? 1 : 0) + '0');
    printf(" ");
}
void getBytes(char* data, BitmapDescriptor* Img){
    byte_t* pos = buf;
    uint8_t bitsLeft = 8;
    int dtch[] = {1, 0};
    int dataLength = strlen(data);
    for(int i = 0; i < dataLength; i++){
        writeBytes((dtch[data[i]-48]), Img->StripeSize, &pos, &bitsLeft);
    }
    endWriting(&pos, &bitsLeft);
    /*for(int i = 0; i < 256; i++){
        printBits(buf[i]);
    }*/

}
void saveData(BitmapDescriptor* Img){
    for(int i = 0; i < dwordAlign(rowBytes(Img->Width)); i++){
        byte_t* ptr = Img->DataPtr + i;
        for(int j = 0; j < Img->Height; j++){
            //*(Img->DataPtr + mover + j) = buf[j];
            if(i >= (Img->StripeSize*numberOfStripes)/8){
                //printf("%d", i);
                //printf(": ");
                *ptr = 255;
                //printBits(*ptr);
                //printf("%d", *ptr);
                //printf("\n");
                ptr += Img->RowSize;
            }
            else{
                *ptr = buf[i];
                ptr += Img->RowSize;
            }
        }
    }
}
void saveBMP(BitmapDescriptor* Img, char* filename){
    FILE* f = fopen(filename, "w");
    fwrite((byte_t*)Img->HeaderPtr, sizeof(byte_t), Img->FileSize, f);
    fclose(f);
}
void createBarcode(char* code, int stripes, char* filename, int height){
    BitmapDescriptor *Img = InitImage((stripes*numberOfStripes), height, stripes);
    char* result = generateCharCode(code);
    getBytes(result, Img);
    saveData(Img);
    saveBMP(Img, filename);
    printf("%s", filename);
    printf(" has been created!\n");
}
int main() {
    //INPUT
    int stripesCounter[] = {5, 8, 10}; //barcodes widths array
    char* code[] = {"590227720655", "900292401188", "978837843117"}; //codes array
    //END OF INPUT
    int c = sizeof(code)/sizeof(code[0]);
    int s = sizeof(stripesCounter)/sizeof(stripesCounter[0]);
    if(c != s){
        printf("Check your input arrays and try again!\n");
        return -1;
    }
    for(int i = 0; i < c; i++){
        char* filename = "barcode";
        filename = concat(filename, code[i]);
        filename = concat(filename, ".bmp");
        createBarcode(code[i], stripesCounter[i], filename, 360);
    }
    //createBarcode(code, stripesCounter, "barcode.bmp");
    return 0;
}