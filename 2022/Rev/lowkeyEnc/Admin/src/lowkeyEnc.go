package main

import (
	"crypto/aes"
	"crypto/cipher"
	"math/rand"
	"fmt"
	"io/ioutil"
	"os"
	"image"
	"image/color"
	"image/png"
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


func (c CBC256) PadByPkcs7(plainText []byte) []byte { // pad the data using PKCS7 padding scheme
	
	padding := aes.BlockSize - (len(plainText) % aes.BlockSize)
	paddedPlaintext := make([]byte, len(plainText)+padding)
	copy(paddedPlaintext, plainText)

	for i := len(plainText); i < len(paddedPlaintext); i++ {
		paddedPlaintext[i] = byte(padding)
	}

	return paddedPlaintext
}


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
	f, err := os.Create("enc.png")
	if err != nil {
		panic(err)
	}
	defer f.Close()
	png.Encode(f, img)
}

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
	
	cbc := CBC256{Key: key, IV: iv}  
	data, err := ioutil.ReadFile(os.Args[1]) // read the file
	if err != nil { // if error, panic
		panic(err)
	}
	
	// encrypt twice
	encrypted := cbc.EncryptByCBC(data)
	final_arr := cbc.EncryptByCBC(encrypted)
	xorenc:= xor_encrypt(final_arr)

	// print xorenc
	// fmt.Println(xorenc)

	byteArrayToImage(xorenc)
}