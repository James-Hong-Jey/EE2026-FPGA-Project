# Imported Standard Modules
import sys
from PIL import Image 

def Convert (ImageName):
	"""
		This converts the given image into a Xilinx Coefficients (.coe) file.
		Pass it the name of the image including the file suffix.
		The file must reside in the directory from which this function is called
		or provide the absolute path. 
	"""
	# Open image
	img 	= Image.open(ImageName)
	# Verify that the image is in the 'RGB' mode, every pixel is described by 
	# three bytes
	if img.mode != 'RGB':
		img = img.convert('RGB')

	# Store Width and height of image
	width 	= img.size[0]
	height	= img.size[1]

	# Create a .coe file and open it.
	# Write the header to the file, where lines that start with ';' 
	# are commented
	filetype = ImageName[ImageName.find('.'):]
	filename = ImageName.replace(filetype,'.mem')
	imgcoe	= open(filename,'w')
	
	# Iterate through every pixel, retain the 3 least significant bits for the
	# red and green bytes and the 2 least significant bits for the blue byte. 
	# These are then combined into one byte and their hex equivalent is written
	# to the .coe file
	cnt = 0
	line_cnt = 0
	for r in range(0, height):
		for c in range(0, width):
			cnt += 1
			# Check for IndexError, usually occurs if the script is trying to 
			# access an element that does not exist
			try:
				R,G,B = img.getpixel((c,r))
			except IndexError:
				print ("Index Error Occurred At:")
				sys.exit()
			# convert the value (0-255) to a binary string by cutting off the 
			# '0b' part and left filling zeros until the string represents 8 bits
			# then slice off the bits of interest with [5:] for red and green
			# or [6:] for blue
			Rb = bin(R)[2:].zfill(8)[:5]
			Gb = bin(G)[2:].zfill(8)[:6]
			Bb = bin(B)[2:].zfill(8)[:5]
			
			Outbyte = Rb+Gb+Bb
			# Check for Value Error, happened when the case of the pixel being 
			# zero was not handled properly	
			try:
				imgcoe.write('%4.4X'%int(Outbyte,2))
			except ValueError:
				print ('Value Error Occurred At:')
				sys.exit()
			# Write correct punctuation depending on line end, byte end,
			# or file end
			if c==width-1 and r==height-1:
				imgcoe.write(';')
			else:
				if cnt%32 == 0:
					imgcoe.write(',\n')
					line_cnt+=1
				else:
					imgcoe.write(',')
	imgcoe.close()


if __name__ == '__main__':
	Convert("noisy.png")