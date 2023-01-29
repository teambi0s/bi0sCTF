package main

import (
	"crypto/aes"
	"crypto/cipher"
	"encoding/base64"
	"math/rand"
	"fmt"
	"io/ioutil"
	"os"
	"image"
	"image/color"
	"image/png"
	"crypto/sha256"
	// "strings"

)

type CBC256 struct {
	Key []byte
	IV []byte
}

func (c CBC256) EncryptByCBC(plainText []byte) []byte { // encrypt the data using AES in CBC mode
	
	block, err := aes.NewCipher(c.Key)
	if err != nil {
		panic(err)
	}

	paddedPlaintext := c.PadByPkcs7([]byte(plainText))

	cipherText := make([]byte, aes.BlockSize+len(paddedPlaintext))

	mode := cipher.NewCBCEncrypter(block, c.IV)
	mode.CryptBlocks(cipherText[:], paddedPlaintext)

	return cipherText[:len(cipherText)-aes.BlockSize]
}

/* EncryptByCBC() is the function that encrypts the data using AES in CBC mode and returns the encrypted data.
1) Create a new cipher block using the key.
2) Pad the plaintext using PKCS7 padding.
3) Create a new cipher block mode using the cipher block and the IV.
4) Encrypt the padded plaintext using the cipher block mode.
5) Return the encrypted data.
*/


func (c CBC256) PadByPkcs7(plainText []byte) []byte { // pad the data using PKCS7 padding scheme
	
	padding := aes.BlockSize - (len(plainText) % aes.BlockSize)
	paddedPlaintext := make([]byte, len(plainText)+padding)
	copy(paddedPlaintext, plainText)

	for i := len(plainText); i < len(paddedPlaintext); i++ {
		paddedPlaintext[i] = byte(padding)
	}

	return paddedPlaintext
}

/*
PadByPkcs7() is the function that pads the data using PKCS7 padding scheme and returns the padded data.
1) Calculate the padding required.
2) Create a new slice of bytes with the length of the plaintext plus the padding.
3) Copy the plaintext to the new slice.
4) Add the padding to the new slice.
5) Return the padded data.
*/


func parallel_encrypt(c CBC256, plainText []byte) []byte {
	
	block, err := aes.NewCipher(c.Key)
	if err != nil {
		panic(err)
	}

	paddedPlaintext := c.PadByPkcs7([]byte(plainText))

	cipherText := make([]byte, aes.BlockSize+len(paddedPlaintext))

	mode := cipher.NewCBCEncrypter(block, c.IV)
	mode.CryptBlocks(cipherText[:], paddedPlaintext)

	return cipherText[:len(cipherText)-aes.BlockSize]
}


// xor each letter with multiple of its ascii value
func xor_encrypt(data []byte) []byte {
	
	encrypted := make([]byte, len(data))
	for i := 0; i < len(data); i++ {
		encrypted[i] = data[i] ^ byte(i)
	}

	return encrypted
}

/*
xor_encrypt() is the function that encrypts the data using XOR encryption and returns the encrypted data.
1) Create a new slice of bytes with the length of the plaintext.
2) XOR each letter with multiple of its ascii value.
3) Return the encrypted data.
*/

// byte array to image
func byteArrayToImage(data []byte) {
	// create a small white image
	img := image.NewRGBA(image.Rect(0, 0, 100, 100))
	// fill it with white
	// append the data to the image at last row
	for i := 0; i < len(data); i++ {
		img.Set(i, 99, color.RGBA{data[i], data[i], data[i], 255})
	}

	// save the image to a file
	f, err := os.Create("image.png")
	if err != nil {
		panic(err)
	}
	defer f.Close()
	png.Encode(f, img)

}

/*
byteArrayToImage() is the function that converts the byte array to an image.
1) Create a new image with the length of the data.
2) Fill the image with white.
3) Append the data to the image at last row.
4) Save the image to a file.
*/

func main() {
	// useage
	if len(os.Args) != 2 {
		fmt.Println("Usage: ./main <filename>")
		os.Exit(1)
	}

	key := make([]byte, 32)
	iv := make([]byte, 16)
	_, err := rand.Read(key)
	if err != nil {
		panic(err)
	}
	// fmt.Println("KEY: ",key)
	if err != nil {
		panic(err)
	}
	_, err = rand.Read(iv)
	if err != nil {
		panic(err)
	}
	// fmt.Println("IV: ",iv)
	cbc := CBC256{Key: key, IV: iv} // create a new instance of CBC256 with random key and iv generated above 
	data, err := ioutil.ReadFile(os.Args[1]) // read the file
	if err != nil { // if error, panic
		panic(err)
	}
	encrypted := cbc.EncryptByCBC(data)
	final_arr := cbc.EncryptByCBC(data)
	// decrypted := cbc.DecryptByCBC(encrypted)
	// fmt.Println("Decrypted:", string(decrypted))
	// fmt.Println("Encrypted:", base64.StdEncoding.EncodeToString(encrypted))
	//decrypted := cbc.DecryptByCBC(encrypted)
	xorenc:= xor_encrypt(encrypted)

	byteArrayToImage(final_arr)
	imgFile, err := os.Open("image.png")
	if err != nil {
		panic(err)
	}
	defer imgFile.Close()
	img, err := png.Decode(imgFile)
	if err != nil {
		panic(err)
	}
	bounds := img.Bounds()
	for y := bounds.Min.Y; y < bounds.Max.Y; y++ {
		for x := bounds.Min.X; x < bounds.Max.X; x++ {
		}
	}
	
	finalData := make([]byte, 0)
	for x := bounds.Min.X; x < bounds.Max.X; x++ {
		finalData = append(finalData, img.At(x, 99).(color.NRGBA).R) // append the data to the finalData slice of bytes 

	}
	// fmt.Println("Final data: ", finalData)
	sha256xorenc :=sha256.Sum256([]byte(base64.StdEncoding.EncodeToString(xorenc)))
	sha256xorencString := string(sha256xorenc[:])

	sha256finalData := sha256.Sum256(finalData)
	sha256finalDataString := string(sha256finalData[:])
	// fmt.Println(sha256xorencString)
	// fmt.Println(sha256finalDataString)
	file, err := os.Open("enc.txt")
	if err != nil {
		panic(err)
	}
	defer file.Close()
	data_auth, err := ioutil.ReadAll(file)
	if err != nil {
		panic(err)
	}
	dataString := string(data_auth)
	// fmt.Println(dataString)
	flag := false
	// print dataString[:32]
	// difference char in dataString[:104] == sha256xorencString
	// fmt.Println(dataString[:67],"\n\n\n\n",sha256xorencString)
	// for i := 0; i < 32; i++ {
	// 	if sha256xorencString[i] != dataString[i] {
	// 		fmt.Println(sha256xorencString[i],":",dataString[i])
	// 	}
	// }
	if dataString[:32] == sha256xorencString {
		for i := 0; i < 32; i++ {
			if sha256finalDataString[i] != dataString[len(dataString)-33+i-1] {
				fmt.Println(sha256finalDataString[i],":",dataString[len(dataString)-33+i-1])
				flag = true
			}
		}
		if flag == false {
			fmt.Println("YEEEEEEEEEEEEEEEEEEETTTTT")
		} else {
			fmt.Println("Brrrrrrrrrrrrrrrrrrrrrrrr")
		}
	} else {
		fmt.Println("NOOOOOOOOOOOOOOOOOOOOOOO   ")
	}


	err = os.Remove("image.png")
	if err != nil {
		panic(err)
	}
	
}
