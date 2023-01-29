# RGB Cheems

### Challenge Description

Cheems is stuck , can you help him?

**Challenge File**:
+ [Primary Link](https://drive.google.com/file/d/1iETVXwWCnUF8_08aQpi8uEblPt1GdFTe/view?usp=sharing)
+ [Mirror Link](https://www.dropbox.com/s/g0w0nrlpqb2bng9/RGB_Cheems.rar?dl=0)

**MD5 Hash**: 8f3cf1f2acbeb10d934ce3e08ced500a

### Short Writeup

+  Use dnSpy to decompile Chall_DataManaged\Assembly-CSharp.dll 
+  Edit values in PlayerController to get speed and jump hax
+  There are empty scripts for both big wall and roof. Disable box collider 2d (GetComponent<BoxCollider2D> ().enabled = false;) for those to pass through wall and the roof.
+  Now you can finish the level normally or by going out of the map with roof boxcollider disabled. 
  
### Flag

bi0sCTF{GG!_H4X_F0R_TH3_WIN!}

### Author

**spektre**