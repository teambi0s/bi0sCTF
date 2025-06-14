#include "parser.hpp"
#include <fstream>
#include <iomanip>
#include <iostream>

MIDI::MIDI(std::ifstream* istr) :

    header(NULL),
    stream(istr),
    curTrck(0) {

}

MIDI::~MIDI() {
    delete header;
}

/* Checks the header */
bool MIDI::chkHeader(std::string hdr) {

    char buf[0x8] = {0};
    stream->read(buf,0x4);

    if (stream->gcount() != 4) {
        errType=MIDI_FILE_TRUNC;
        return false;
    } 
    
    if(buf[0] != '\x00' && buf == hdr) {
        return true;
    } 
    
    return false;

}

std::string MIDI::getStatus(){
    
    switch (errType) {
        case MIDI_BAD_HEADER:
            return "[JAMP]: BAD HEADER -- not a midi file";
        case MIDI_FILE_TRUNC:
            return "[JAMP]: EOF ERROR -- midi file ended awkwardly";
        case MIDI_BAD_TRACK:
            return "[JAMP]: BAD TRACK -- malformed track";
        case MIDI_INVALID_EVENT:
            return "[JAMP]: BAD EVENT -- parsed event is invalid";
        case BAD_MIDI_EVENT:
            return "[JAMP]: BAD MIDI EVENT -- midi event parsed is invalid";
        case BAD_META_EVENT:
            return "[JAMP]: BAD META EVENT -- meta event parsed is unsupported";
        case BAD_META_VALUE:
            return "[JAMP]: BAD META VALUE -- Invalid meta event field";
        default:
            return "[JAMP]: STATUS OK ";
    }

}

bool MIDI::chkStream(int nbytes) {
    
    if(errType != 0) {
        return false;
    }
    if (nbytes > parseSz) {
        errType=MIDI_FILE_TRUNC;
        return false;
    } 

    parseSz = 0;
    return true;
}

uint64_t MIDI::fetchBig8(){
    uint64_t x = 0;
    stream->read(reinterpret_cast<char *>(&x),0x1);
    if(stream->gcount() != 1) { 
            errType=MIDI_FILE_TRUNC;
            return false; 
    }
    parseSz += 0x1;
    return x;
}

uint64_t MIDI::fetchBig16(){
    uint64_t x = 0;
    stream->read(reinterpret_cast<char *>(&x),0x2);
    if(stream->gcount() != 2) { 
            errType=MIDI_FILE_TRUNC;
            return false; 
    }
    parseSz += 0x2;
    x = __builtin_bswap16(x);
    return x;

}

uint64_t MIDI::fetchBig32(){
    uint64_t x = 0;
    stream->read(reinterpret_cast<char *>(&x),0x4);
    if(stream->gcount() != 4) { 
            errType=MIDI_FILE_TRUNC;
            return false; 
    }
    parseSz += 0x4;
    x = __builtin_bswap32(x);
    return x;

}

uint64_t MIDI::parseVarInt() {
    uint64_t x = 0;
    uint8_t num = 0;
    uint8_t bread= 0;
    do {
        stream->read(reinterpret_cast<char *>(&num),0x1);
        x <<= 0x7;
        x |= (num & 0x7f);
        bread++;
    }
    while(num & 0x80);
    parseSz+=bread;
    return x;
}

bool MIDI::setupMidiEvent(MIDI_EVENT *event,uint8_t type,uint32_t dtime) {

    bool buffered = false;
    event->vtime = dtime;

    if(!(type & 0x80)) {
        MIDI_EVENT last = *(tracks.back()->midi_events.rbegin() + 1);
        event->type = last.type;
        event->channel = last.channel;
        buffered = true;
    } else {
        event->type = type >> 0x4;
        event->channel = type & 0xf;
    }

    if(buffered) {return true;} 

    event->type = type >> 0x4;
    event->channel = type & 0xf;

    if((((type >> 0x4) & 0xf) == MTYPE_PROGRAM_CHANGE || ((type >> 0x4) & 0xf) == MTYPE_CHANNEL_AFTERTOUCH)) {
        event->parameter1 = fetchBig8();
        event->parameter2 = 0x0;
    } else {
        event->parameter1 = fetchBig8();
        event->parameter2 = fetchBig8();
    }
    
    chkStream(0x3);

    return true;
}

bool MIDI::getVec(std::vector<char>* vec,uint32_t sz) {
    uint32_t i = sz;
    char z;
    while(i != 0) {
        i--;
        stream->read(&z,1);
        if(stream->gcount() != 1) { 
            errType=BAD_META_VALUE;
        return false; }
        vec->push_back(z);
    } return true;
}

void printVec(std::vector<char>* vec) {
    int i = 0;
    while(i < vec->size()) {
        std::cout << *(vec->begin() + i);
        i++;
    }
}

void printVecH(std::vector<char>* vec) {
    int i = 0;
    while(i < vec->size()) {
        if(i > 2) {
            printf("...");
            break;
        }
        printf("%x ",*(vec->begin() + i));
        i++;
    }
}

bool MIDI::setupMetaEvent(META_EVENT *event,uint32_t dtime) {

    int status;
    event->vtime = dtime;
    event->type = fetchBig8();
    
    event->len = parseVarInt();
    status = getVec(&event->data,event->len);

    if(event->type == MTA_END_OF_TRACK)
        tracks.back()->EOT = true;
    
    // Propagate error if bad
    if(status == false){
        return false;
    }
    
    return true;

}

bool MIDI::setupSysxEvent(SYSEX_EVENT *event,uint32_t dtime,uint32_t type) {
    int status;
    event->vtime = dtime;
    event->e_type = 0xF0;
    event->len = parseVarInt();
    status = getVec(&event->data,event->len);
    return true;
}

bool MIDI::parseHeader() {

    header = new MIDI_HEADER();
    
    // propagate failure on bad header(char)(
    if(!chkHeader(header->header)) {
        errType=MIDI_BAD_HEADER;
        return false;
    }

    // Parsing headers
    header->len = fetchBig32();
    header->fmt = fetchBig16();
    header->ntrks = fetchBig16();
    header->div = fetchBig16();

    return chkStream(HEADER_SZ);
    
}

bool MIDI::parseTrack() {

    bool state = true; 
    uint32_t dtime = 0;

    tracks.push_back(new TRACK_CHNK());

    if(!chkHeader(tracks[curTrck]->header)) {
        errType=MIDI_BAD_TRACK;
        return false;
    }
    
    header->len = fetchBig32();
    if(!chkStream(0x4)) { return false; }

    tracks[curTrck]->EOT = false;
    tracks[curTrck]->midi_events = std::vector<MIDI_EVENT>();
    tracks[curTrck]->meta_events = std::vector<META_EVENT>();
    tracks[curTrck]->sysx_events = std::vector<SYSEX_EVENT>();

    int i = 0;
    while( state==true && tracks[curTrck]->EOT==false ) {
        dtime = parseVarInt();
        uint32_t Type=fetchBig8();

        // we dont wanna keep parsing something that doesnt exist :D
        if(stream->eof()) {
            errType = MIDI_FILE_TRUNC;
            return false;
        }
    
        if (Type < 0xf0) {
            tracks[curTrck]->midi_events.push_back(MIDI_EVENT());
            state = setupMidiEvent(&tracks[curTrck]->midi_events.back(),Type,dtime);
            if(!state)
                goto bad_event;
        }

        else if (Type == 0xff) {
            tracks[curTrck]->meta_events.push_back(META_EVENT());
            state = setupMetaEvent(&tracks[curTrck]->meta_events.back(),dtime);
            if(!state)
                goto bad_event;
        }
        
        else if (Type >= 0xf0) {
            tracks[curTrck]->sysx_events.push_back(SYSEX_EVENT());
            state = setupSysxEvent(&tracks[curTrck]->sysx_events.back(),dtime,Type);
            if(!state)
                goto bad_event;
        }

        else {
            errType=MIDI_INVALID_EVENT;
            bad_event:
            return false;
        }
    }

    curTrck++;
    return true;

}

bool MIDI::parseMIDI() {
    std::setvbuf(stdout, nullptr, _IONBF, 0);
    bool status;
    status = parseHeader();
    if(status == false) {return status;}

    tracks = std::vector<TRACK_CHNK*>();
    for (int i=0;(i < header->ntrks && status == true);i++) {

        status = parseTrack();

    }

    return status;

}

/*|────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────|*/
/*|     DUMPING FUNCTIONS : DONT LOOK FOR BUGS HERE                                                                                            |*/
/*|────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────|*/

void MIDI::showHeader() {
    
    std::cout << "━━━━━━━━━━━━━━━━━━ [HEADER] ━━━━━━━━━━━━━━━━━━━" << std::endl;
    std::cout << ">> MIDI HEADER LENGTH : "  <<  header->len << std::endl;
    std::string ttype = header->fmt == 0 ? 
                        "Single Track" : header->fmt == 1 ? 
                                        "Multi-Track synchronous" : "Multi-Track asynchronous";

    std::cout << ">> MIDI FILE TYPE FMT : " << ttype << std::endl;
    std::cout << ">> NO OF MIDI TRACKS  : " << header->ntrks << std::endl;
    std::cout << ">> TIME DIVISION      : " << header->div << std::endl;

}

void MIDI::showMidiTrk(std::vector<MIDI_EVENT> *events) {
    MIDI_EVENT event;
    std::cout << "──────────────[ MIDI TRACK INFO ]──────────────" << std::endl;
    std::vector<MIDI_EVENT>::iterator itr = events->begin();
    resetOctaves();
    for(int i=0;i<events->size();i++) {
        event = *itr;
        std::cout << std::left << std::setw(5) 
                    << event.vtime << "｜" << std::setw(5);
        switch(event.type) {
            case MTYPE_NOTE_OFF:
                std::cout << std::setw(14)  << "[Note] Off :: ";
                showNote(event.parameter1,false);
                break;
            case MTYPE_NOTE_ON:
                std::cout << std::setw(14) << "[Note] On :: ";
                setOctaveTbl(&event);
                showNote(event.parameter1,false);
                break;
            case MTYPE_NOTE_AFTERTOUCH:
                std::cout << std::setw(14) << "[Note] Aftertouch :: ";
                showNote(event.parameter1,false);
                break;
            case MTYPE_CONTROLLER:
                std::cout << "[+] Control Change to No : " << (int)(event.parameter1) << "|  CVal " << (int)(event.parameter2);
                break;
            case MTYPE_PROGRAM_CHANGE:
                std::cout << "[+] Program Change to No : " << (int)(event.parameter1);
                break;
            case MTYPE_CHANNEL_AFTERTOUCH:
                std::cout << "[+] Channel pressure val : " << (int)(event.parameter1);
                break;
            case MTYPE_PITCH_BEND:
                std::cout << "[+] Pitch bend :: " << ((event.parameter1 << 0x7) || event.parameter2);
                break;
            default:
                break;
        }

        std::cout << std::endl;
        itr += 1;
    }
}

char OCTAVE_TBL[12][12] = {"c","c#","d","d#","e","f","f#","g","g#","a","A","b"};

void MIDI::resetOctaves() {
    if(!Octves){
        Octves = new (NOTE_INFO);
        Octves->notes.note = std::vector<char>(OCTAVE_FF,0);
        Octves->notes.count = std::vector<uint8_t>(OCTAVE_FF,0);
    for(int i=0;i<OCTAVE_FF;i++) {
            Octves->notes.note[i] = i;
        }
    } else {
        for(int i=0;i<OCTAVE_FF;i++) {
            Octves->notes.count[i] = 0;
        }
    }

    Octves->noteBuf = std::vector<char>();
}

void MIDI::setOctaveTbl(MIDI_EVENT *event) {
    (*(Octves->notes.count.begin() + event->parameter1))++;
    Octves->noteBuf.push_back(*(Octves->notes.note.begin() + event->parameter1));
}

void MIDI::showNote(int i,bool tref) {
    std::cout << "NOTE " << std::setw(5) << (char *)OCTAVE_TBL[((*(Octves->notes.note.begin() + i)) % 12)] 
                << "| OCTAVE " << (*(Octves->notes.note.begin() + i) / 11);
    if(tref) 
        std::cout << " = " << (int)(*(Octves->notes.count.begin() + i));
}

void MIDI::showOctaves() {
     std::cout << "──────────────[ OCTAVE TABLE INFO ]──────────────" << std::endl;
    for(int i=0;i<OCTAVE_FF;i++) {
        showNote(i,true);
        std::cout << std::endl;
    }
}

void MIDI::showPlayedNotes() {
    std::cout << "──────────────[ FEW NOTES PLAYED IN TRACK ]──────────────" << std::endl;
    for(int i=0;i<Octves->noteBuf.size();i++) {
        if(i > 10) {
            break;
        }
        showNote(i,true);
        std::cout << std::endl;
    }
}

void MIDI::showMetaTrk(std::vector<META_EVENT> *events) {
    META_EVENT event;
    std::cout << "──────────────[ META TRACK INFO ]──────────────" << std::endl;
    std::vector<META_EVENT>::iterator itr = events->begin();
    for(int i=0;i<events->size();i++) {
        event = *itr;
        std::string e_type = "";
        switch(event.type) {
        case MTA_SEQ_NUM:
            e_type = "[META] Seq spec";
            break;
        case MTA_TEXT_EVENT:
            e_type = "[META] Text";
            break;
        case MTA_COPYRIGHT_NOTICE:
            e_type = "[META] Copyright Notice";
            break;
        case MTA_TRACK_NAME:
            e_type = "[META] Track Name";
            break;
        case MTA_INSTR_NAME:
            e_type = "[META] Instrument Name";
            break;
        case MTA_LYRICS:
            e_type = "[META] Lyrics";
            break;
        case MTA_MARKER:
            e_type = "[META] Marker";
            break;
        case MTA_CUE_PT:
            e_type = "[META] Cue point";
            break;
        case MTA_TRACK_INFO:
            e_type = "[META] Track info";
        case MTA_MIDI_PREFIX:
            e_type = "[META] MIDI Prefix";
            break;
        case MTA_END_OF_TRACK:
            e_type = "[META] END OF TRACK";
            tracks.back()->EOT = true;
            break;
        case MTA_SET_TEMPO:
            e_type = "[META] Set Tempo";
            break;
        case MTA_SMPTE_OFFT:
            e_type = "[META] SMPTE Offt";
            break;
        case MTA_TIME_SIGN:
            e_type = "[META] Time Signature";
            break;
        case MTA_KEY_SIGN:
            e_type = "[META] Key Signature";
            break;
        case MTA_SEQ_SPECIFIC:
            e_type = "[META] Sequencer Specific Info";
            break;
        default:
            e_type = "[META] Unsupported Event Type";
    }
        std::cout << "[+] " <<  event.vtime << " : " << e_type << " : ";
    if(event.type < 0x8) {
        printVec(&event.data);
    } else {
        switch(event.type) {
            case MTA_MIDI_PREFIX:
                std::cout << "set Channel : " << event.data[2];
                break;
            case MTA_SET_TEMPO:
                std::cout << "[µs] " << *((int *)(&event.data[0]));
                break;
            case MTA_SMPTE_OFFT:
                std::cout << "[META] SMPTE Offt";
                break;
            case MTA_TIME_SIGN:
                std::cout << (int)event.data[0] << "/" << (int)event.data[1] << " : " << (int)event.data[2] << "|" << (int)event.data[3];
                break;
            case MTA_KEY_SIGN:
                if(event.data[0] < 0) {
                    std::cout << (int)event.data[0] << " FLAT/ FLATS";
                } else if (!event.data[0]) {
                    std::cout << "Key of C";
                } else {
                    std::cout << (int)event.data[0] << " SHARP/ SHARPS";
                } std::cout << ((event.data[1] == 0) ? "| MAJOR KEY" : "| MINOR KEY");
                break;
            case MTA_SEQ_SPECIFIC:
                std::cout << "Trust me its in here";
                break;
            default:
                break;
            }
        }
        std::cout << std::endl;
        itr += 1;
        e_type.clear();
    }

}

void MIDI::showSysxTrk(std::vector<SYSEX_EVENT> *events) {
    std::cout << "──────────────[ SYSX TRACK INFO ]──────────────" << std::endl;
    SYSEX_EVENT *event;
    std::vector<SYSEX_EVENT>::iterator itr = events->begin();
    for(int i=0;i<events->size();i++) {
        printf("SYSEX EVENT : LEN => %d | ",(int)itr->len);
        printVecH(&itr->data); 
        std::cout << std::endl;
        itr += 1;
    }
}


void MIDI::showTrck() {
    for (int i=0;i<tracks.size();i++) {
        std::cout << "━━━━━━━━━━━━━━━ < TRACK NO " << i << " > ━━━━━━━━━━━━━━━━" << std::endl;
        showMidiTrk(&tracks[i]->midi_events);
        showMetaTrk(&tracks[i]->meta_events);
        showSysxTrk(&tracks[i]->sysx_events);
        showOctaves();
        showPlayedNotes();
    }
}

void MIDI::showMIDI() {
    if(errType) {
        std::cout << getStatus() << std::endl;
        return;
    }

    std::cout << "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" << std::endl;
    std::cout << "      <<<<<<<< SHOWING MIDI DATA >>>>>>>> " << std::endl;
    showHeader();
    showTrck();
    return;
}

