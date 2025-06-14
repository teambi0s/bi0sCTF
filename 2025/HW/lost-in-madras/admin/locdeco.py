def fromhex(data: str):
    return bytearray.fromhex(data)

def extract_bitpos(data: str, bitpos: int, length: int):
    bin_data = ''.join(f'{byte:08b}' for byte in data)
    select_data = bin_data[bitpos:bitpos+length]
    select_value = int(select_data, 2)
    return select_value

def decode_gps(data):
    gps_latitude_deg = extract_bitpos(data, 0, 8)
    gps_latitude_min = extract_bitpos(data, 8, 6)
    gps_latitude_min_dec = extract_bitpos(data, 14, 14)
    
    gps_longitude_deg = extract_bitpos(data, 28, 9)
    gps_longitude_min = extract_bitpos(data, 37, 6)
    gps_longitude_min_dec = extract_bitpos(data, 43, 14)

    lat_deg = gps_latitude_deg - 89
    lon_deg = gps_longitude_deg - 179
    
    lat_total_min = gps_latitude_min + gps_latitude_min_dec * 0.0001
    lon_total_min = gps_longitude_min + gps_longitude_min_dec * 0.0001
    
    latitude = lat_deg + (lat_total_min / 60.0)
    longitude = lon_deg + (lon_total_min / 60.0)
    
    latitude = round(latitude, 5)
    longitude = round(longitude, 5)
    
    return latitude, longitude

data = fromhex("66 0D F4 48 1A 0E DD 00")
lat, lon = decode_gps(data)
print(f"Latitude: {lat}, Longitude: {lon}")

