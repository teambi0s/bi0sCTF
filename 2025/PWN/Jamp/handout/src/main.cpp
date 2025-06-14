#include <iostream>
#include <fstream>
#include "parser.cpp"


int main(int argc,char *argv[]) {

    if (argc != 2) {
        std::cout << "[Format]: ./midiocre <File>" << std::endl;
        exit(1);
    }

    std::cout << "[+] OPENING FILE : " << argv[1] << std::endl;
    
    std::ifstream fileStream(argv[1],std::ios::binary);
    
    if(!fileStream) {
        std::cout << "[Error]: File does not exist" << std::endl;
        exit(1);
    }
    
    MIDI *File = new MIDI(&fileStream);
    bool x = File->parseMIDI();
    File->showMIDI();
    
}
