import numpy as np
import librosa
import librosa.display

# Calculated: BASE_FREQ + symbol * 150, PREAMBLE_FREQ, POSTAMBLE_FREQ 
ALLOWED_FREQS = np.array([
    0, 2000, 2150, 2300, 2450,
    2600, 2750, 2900, 3050,
    2800, 3200
])

PREAMBLE_PATTERN = [2800, 2300, 2800, 2300, 2800, 2300, 2800, 2300, 0]
POSTAMBLE_PATTERN = [0, 3200, 3050, 2900, 2750, 2600]

def snap_frequency(freq):
    idx = np.argmin(np.abs(ALLOWED_FREQS - freq))
    return ALLOWED_FREQS[idx]

def analyze_audio_snapped(audio_path, chunk_duration_ms=20):
    y, sr = librosa.load(audio_path, sr=None)
    print(f"Loaded {audio_path}, Sampling Rate: {sr} Hz")

    samples_per_chunk = int(sr * (chunk_duration_ms / 1000.0))
    total_samples = len(y)

    print(f"Chunk size: {samples_per_chunk} samples ({chunk_duration_ms} ms each)")

    raw_results = []

    for start in range(0, total_samples, samples_per_chunk):
        end = min(start + samples_per_chunk, total_samples)
        chunk = y[start:end]

        if len(chunk) < samples_per_chunk // 2:
            continue

        windowed = chunk * np.hanning(len(chunk))
        n_fft = 2 ** int(np.ceil(np.log2(len(windowed))))
        fft_result = np.fft.rfft(windowed, n=n_fft)
        freqs = np.fft.rfftfreq(n_fft, 1 / sr)
        magnitude = np.abs(fft_result)

        peak_idx = np.argmax(magnitude)
        dominant_freq = freqs[peak_idx]

        snapped_freq = snap_frequency(dominant_freq)

        start_time = start / sr
        end_time = end / sr

        raw_results.append((snapped_freq, start_time, end_time))

    grouped = []
    if raw_results:
        last_freq, start_time, end_time = raw_results[0]
        for freq, s_time, e_time in raw_results[1:]:
            if freq == last_freq:
                end_time = e_time
            else:
                grouped.append((last_freq, start_time, end_time))
                last_freq = freq
                start_time = s_time
                end_time = e_time
        grouped.append((last_freq, start_time, end_time))
        
    return grouped

def find_ambles(arr, pattern):
    n = len(arr)
    m = len(pattern)
    matches = []

    for i in range(n - m + 1):
        if arr[i:i+m] == pattern:
            matches.append((i, i + m - 1))
    return matches

def extract_messages(grouped_records):
    only_freq = [int(i[0]) for i in grouped_records]
    PREAMBLES = find_ambles(only_freq, PREAMBLE_PATTERN)
    POSTAMBLES = find_ambles(only_freq, POSTAMBLE_PATTERN)
    
    messages = []
    if len(PREAMBLES) != len(POSTAMBLES):
        print("[!] Messages are incomplete.")
        exit(-1)
    print("[+] Found PREAMBLES and POSTAMBLES")
    
    print(PREAMBLES, POSTAMBLES)
    
    for i in range(len(PREAMBLES)):
        msg = []
        for freq, start, end in grouped_records[PREAMBLES[i][1]+1:POSTAMBLES[i][0]]:
            duration = round(end - start, 3) + 0.02 # hotfix
            for _ in range(int(duration*1000)//80):
                msg.append(freq)
        messages.append(msg)
    return messages

def get_symbol(freq):
    symbol = (freq - 2000) // 150
    return str(symbol)

def decode_messages(messages):
    final_msg = []
    current_key = [0x3E,0x65,0x3F,0xE8,0x18,0xFA,0x25,0x3D,0x8C,0x48,0xA4,0xA,0x1B,0x83,0x77,0xD3,0x71,0x9D,0xC9,0xE4,0x6C,0x7F,0x7D,0x4E,0x30,0x4,0x86,0xBB,0xA2,0x5D,0xAC,0x19,0xA4,0x50,0x0,0xD6, 0, 0]
    ct = 0
    for msg in messages:
        for i in range(0, len(msg) - 2, 3):
            octal_val = "0o"+get_symbol(msg[i])+get_symbol(msg[i+1])+get_symbol(msg[i+2])
            int_val = int(octal_val, 8)
            decoded_byte = chr((int_val ^ current_key[ct]) % 251)
            final_msg.append(decoded_byte)
            ct += 1
            # print(int(msg[i]), int(msg[i+1]), int(msg[i+2]), end=" : ")
            # print(octal_val[2:], decoded_byte, sep = " -> ")
    return "".join(final_msg)

def main():
    audio_path = "ze_beeps.wav"
    grouped_records = analyze_audio_snapped(audio_path)
    messages = extract_messages(grouped_records)
    print(decode_messages(messages))

if __name__ == "__main__":
    main()
