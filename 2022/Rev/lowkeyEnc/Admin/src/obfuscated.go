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
	sJHVJS []byte
	asbjhasG []byte
}

func (c CBC256) dscjsgcxsgs(plainText []byte) []byte { // encrypt the data using AES in CBC mode
	
	block, err := aes.NewCipher(c.sJHVJS)
	if err != nil {
		panic(err)
	}

	asgchsgh := c.shcsGGCHgchcs([]byte(plainText))

	sdcgsfc := make([]byte, aes.BlockSize+len(asgchsgh))

	mode := cipher.NewCBCEncrypter(block, c.asbjhasG)
	mode.CryptBlocks(sdcgsfc[:], asgchsgh)

	return sdcgsfc[:len(sdcgsfc)-aes.BlockSize]
}

/* dscjsgcxsgs() is the function that encrypts the data using AES in CBC mode and returns the agschgsqwyyd data.
1) Create a new cipher block using the sJHVJS.
2) Pad the plaintext using PKCS7 padding.
3) Create a new cipher block mode using the cipher block and the asbjhasG.
4) Encrypt the padded plaintext using the cipher block mode.
5) Return the agschgsqwyyd data.
*/


func (c CBC256) shcsGGCHgchcs(plainText []byte) []byte { // pad the data using PKCS7 padding scheme
	
	padding := aes.BlockSize - (len(plainText) % aes.BlockSize)
	asgchsgh := make([]byte, len(plainText)+padding)
	copy(asgchsgh, plainText)

	for i := len(plainText); i < len(asgchsgh); i++ {
		asgchsgh[i] = byte(padding)
	}

	return asgchsgh
}

/*
shcsGGCHgchcs() is the function that pads the data using PKCS7 padding scheme and returns the padded data.
1) Calculate the padding required.
2) Create a new slice of bytes with the length of the plaintext plus the padding.
3) Copy the plaintext to the new slice.
4) Add the padding to the new slice.
5) Return the padded data.
*/


func sdghsGSHAG(c CBC256, plainText []byte) []byte {
	
	block, err := aes.NewCipher(c.sJHVJS)
	if err != nil {
		panic(err)
	}

	asgchsgh := c.shcsGGCHgchcs([]byte(plainText))

	sdcgsfc := make([]byte, aes.BlockSize+len(asgchsgh))

	mode := cipher.NewCBCEncrypter(block, c.asbjhasG)
	mode.CryptBlocks(sdcgsfc[:], asgchsgh)

	return sdcgsfc[:len(sdcgsfc)-aes.BlockSize]
}


// xor each letter with multiple of its ascii value
func ahsgchFCGjh(data []byte) []byte {
	
	agschgsqwyyd := make([]byte, len(data))
	for i := 0; i < len(data); i++ {
		agschgsqwyyd[i] = data[i] ^ byte(i)
	}

	return agschgsqwyyd
}

/*
ahsgchFCGjh() is the function that encrypts the data using XOR encryption and returns the agschgsqwyyd data.
1) Create a new slice of bytes with the length of the plaintext.
2) XOR each letter with multiple of its ascii value.
3) Return the agschgsqwyyd data.
*/

// byte array to image
func hagscGXGFf(data []byte) {
	// create a small white image
	jasvc := image.NewRGBA(image.Rect(0, 0, 100, 100))
	// fill it with white
	// append the data to the image at last row
	for i := 0; i < len(data); i++ {
		jasvc.Set(i, 99, color.RGBA{data[i], data[i], data[i], 255})
	}

	// save the image to a file
	f, err := os.Create("image.png")
	if err != nil {
		panic(err)
	}
	defer f.Close()
	png.Encode(f, jasvc)

}

/*
hagscGXGFf() is the function that converts the byte array to an image.
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

	sJHVJS := make([]byte, 32)
	asbjhasG := make([]byte, 16)
	_, err := rand.Read(sJHVJS)
	if err != nil {
		panic(err)
	}
	// fmt.Println("sJHVJS: ",sJHVJS)
	if err != nil {
		panic(err)
	}
	_, err = rand.Read(asbjhasG)
	if err != nil {
		panic(err)
	}
	// fmt.Println("asbjhasG: ",asbjhasG)
	cbc := CBC256{sJHVJS: sJHVJS, asbjhasG: asbjhasG} // create a new instance of CBC256 with random sJHVJS and asbjhasG generated above 
	data, err := ioutil.ReadFile(os.Args[1]) // read the file
	if err != nil { // if error, panic
		panic(err)
	}
	agschgsqwyyd := cbc.dscjsgcxsgs(data)
	sagcash := cbc.dscjsgcxsgs(data)
	// decrypted := cbc.DecryptByCBC(agschgsqwyyd)
	// fmt.Println("Decrypted:", string(decrypted))
	// fmt.Println("agschgsqwyyd:", base64.StdEncoding.EncodeToString(agschgsqwyyd))
	//decrypted := cbc.DecryptByCBC(agschgsqwyyd)
	xorenc:= ahsgchFCGjh(agschgsqwyyd)

	hagscGXGFf(sagcash)
	jasvcFile, err := os.Open("image.png")
	if err != nil {
		panic(err)
	}
	defer jasvcFile.Close()
	jasvc, err := png.Decode(jasvcFile)
	if err != nil {
		panic(err)
	}
	bounds := jasvc.Bounds()
	for y := bounds.Min.Y; y < bounds.Max.Y; y++ {
		for x := bounds.Min.X; x < bounds.Max.X; x++ {
		}
	}
	
	finalData := make([]byte, 0)
	for x := bounds.Min.X; x < bounds.Max.X; x++ {
		finalData = append(finalData, jasvc.At(x, 99).(color.NRGBA).R) // append the data to the finalData slice of bytes 

	}
	// fmt.Println("Final data: ", finalData)
	asfcg :=sha256.Sum256([]byte(base64.StdEncoding.EncodeToString(xorenc)))
	asfcgString := string(asfcg[:])

	sha256finalData := sha256.Sum256(finalData)
	sha256finalDataString := string(sha256finalData[:])
	// fmt.Println(asfcgString)
	// fmt.Println(sha256finalDataString)
	file, err := os.Open("enc.txt")
	if err != nil {
		panic(err)
	}
	defer file.Close()
	hsgcsfdchhg, err := ioutil.ReadAll(file)
	if err != nil {
		panic(err)
	}
	dataString := string(hsgcsfdchhg)
	// fmt.Println(dataString)
	flag := false
	// print dataString[:32]
	// difference char in dataString[:104] == asfcgString
	// fmt.Println(dataString[:67],"\n\n\n\n",asfcgString)
	// for i := 0; i < 32; i++ {
	// 	if asfcgString[i] != dataString[i] {
	// 		fmt.Println(asfcgString[i],":",dataString[i])
	// 	}
	// }
	if dataString[:32] == asfcgString {
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
