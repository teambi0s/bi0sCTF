#include <fstream>
#include <vector>
#include <stdint.h>

#define HEADER_SZ 0xA

enum MIDI_ERRORS {

    MIDI_ALL_GUD,
    MIDI_BAD_HEADER,
    MIDI_FILE_TRUNC,
    MIDI_BAD_TRACK,
    MIDI_INVALID_EVENT,
    BAD_MIDI_EVENT,
    BAD_META_EVENT,
    BAD_META_VALUE

};

enum midi_event_type {

    MTYPE_NOTE_OFF           = 0x8,
    MTYPE_NOTE_ON            = 0x9, 
    MTYPE_NOTE_AFTERTOUCH    = 0xA, 
    MTYPE_CONTROLLER         = 0xB, 
    MTYPE_PROGRAM_CHANGE     = 0xC,
    MTYPE_CHANNEL_AFTERTOUCH = 0xD, 
    MTYPE_PITCH_BEND 	     = 0xE

};

enum meta_event_type {

    MTA_SEQ_NUM           = 0x0,
    MTA_TEXT_EVENT        = 0x01,  
    MTA_COPYRIGHT_NOTICE  = 0x02, 
    MTA_TRACK_NAME        = 0x03,  
    MTA_INSTR_NAME        = 0x04, 
    MTA_LYRICS            = 0x05, 
    MTA_MARKER            = 0x06, 
    MTA_CUE_PT            = 0x07,
    MTA_TRACK_INFO        = 0x08,
    MTA_MIDI_PREFIX       = 0x20,
    MTA_END_OF_TRACK      = 0x2f,
    MTA_SET_TEMPO         = 0x51, 
    MTA_SMPTE_OFFT        = 0x54,
    MTA_TIME_SIGN         = 0x58,
    MTA_KEY_SIGN          = 0x59, 
    MTA_SEQ_SPECIFIC      = 0x7f

};

struct MIDI_EVENT {

    uint32_t vtime;
    uint8_t type;
    int8_t  channel;
    int8_t  parameter1;
    int8_t  parameter2;

};

struct META_EVENT {

    uint32_t vtime;
    uint8_t type;
    uint32_t len;
    std::vector<char> data;

};

struct SYSEX_EVENT {

    uint32_t vtime;
    uint8_t e_type;
    uint32_t len;
    std::vector<char> data;

};

struct MIDI_HEADER {

    std::string header="MThd";
    uint32_t len;
    uint32_t fmt;
    uint32_t ntrks;
    uint32_t div;

};

#define OCTAVE_FF 0x7F

struct NOTE_EN { 
    std::vector<char> note;
    std::vector<uint8_t> count;
};

struct NOTE_INFO {
    std::vector<char> noteBuf;
    NOTE_EN notes;
};

class TRACK_CHNK {

    public:
    TRACK_CHNK() {
        
        len = 0;
        curEl = 0;
        midi_events = std::vector<MIDI_EVENT>();
        meta_events = std::vector<META_EVENT>();
        sysx_events = std::vector<SYSEX_EVENT>();
        
    }
    
    bool EOT;
    uint32_t curEl;
    std::string header="MTrk";
    uint32_t len;
    std::vector<MIDI_EVENT>  midi_events;
    std::vector<META_EVENT>  meta_events;
    std::vector<SYSEX_EVENT> sysx_events;
};

class MIDI {

    public:
    MIDI(std::ifstream* stream);
    ~MIDI();
    bool parseMIDI();
    void showMIDI();

    /* Initial Headers */
    private:
    int errType = 0;
    int parseSz = 0;
    int curTrck;
    NOTE_INFO *Octves;
    MIDI_HEADER* header;
    std::ifstream* stream;
    std::vector<TRACK_CHNK*> tracks;

    /* Byte Handlers */
    std::string getStatus();
    uint64_t fetchBig8();
    uint64_t fetchBig16();
    uint64_t fetchBig32();
    uint64_t parseVarInt();

    /* Event parsers */
    bool setupMidiEvent(MIDI_EVENT *event,uint8_t type,uint32_t dtime);
    bool setupSysxEvent(SYSEX_EVENT *event,uint32_t type,uint32_t dtime);
    bool setupMetaEvent(META_EVENT *event,uint32_t dtime);
   
    /* Primitive parser Functions */    
    bool parseHeader();
    bool parseTrack();
    void getMetaEvent();
    void getMidiEvent();
    void getSysxEvent();
    void resetOctaves();
    bool chkStream(int nbytes);
    bool chkHeader(std::string hdr); 
    const char *findMetaStr(uint32_t eType);
    const char *findMidiStr(uint32_t eType);
    const char *findSysxStr(uint32_t eType);
    const char *MIDIprintErr();
    bool getVec(std::vector<char>* vec,uint32_t sz);

    void showHeader();
    void showNote(int n,bool tref);
    void setOctaveTbl(MIDI_EVENT *event);
    void showPlayedNotes();
    void showOctaves(); 
    void showMetaTrk(std::vector<META_EVENT>  *event);
    void showMidiTrk(std::vector<MIDI_EVENT>  *event);
    void showSysxTrk(std::vector<SYSEX_EVENT> *event);
    void showTrck();

};