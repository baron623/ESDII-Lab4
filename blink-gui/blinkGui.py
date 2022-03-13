#Max Baron
#ESD II - Lab 4

import sys
import time
import mmap
import struct
#from PyQt4.QtGui import *
#from PyQt4.QtCore import *
from PyQt4 import QtGui, QtCore

class Example(QtGui.QWidget):
    
    def __init__(self):
        super(Example, self).__init__()
        self.val = 1
        
        self.initUI()
        
        
    def initUI(self):      

        self.col = QtGui.QColor(0, 0, 0)       
        
        #Freq TitleLabel
        self.labelFreqTitle = QtGui.QLabel(self)
        self.labelFreqTitle.setText("Frequency")

        #Frequency Slider
        self.freq = QtGui.QSlider(QtCore.Qt.Horizontal, self)
        #freq_slider.setGeometry(30, 40, 100, 30)
        self.freq.setSingleStep(1)
        self.freq.setMinimum(1)
        self.freq.setMaximum(255)
        self.freq.valueChanged[int].connect(self.freqEditChanged)

        # Frequency Edit Slider
        self.FreqEdit = QtGui.QLineEdit(self)
        self.FreqEdit.returnPressed.connect(self.freqEditChanged)

        self.square = QtGui.QFrame(self)
        #self.square.setGeometry(150, 20, 100, 100)
        self.square.setStyleSheet("QWidget { background-color: %s }" %  
            self.col.name())
        
        #Grid Layout
        grid = QtGui.QGridLayout()
        self.setLayout(grid)
        grid.addWidget(self.labelFreqTitle, 0,0)
        grid.addWidget(self.freq, 1,0)
        grid.addWidget(self.FreqEdit, 1,1)
        #grid.addWidget(self.square, 2,2)
        grid.setSpacing(5)

        self.setGeometry(300, 300, 280, 170)
        self.setWindowTitle('Lab 4 - Blink')
        self.show()
        
    def sliderValChanged(self):
        #self.sliderlbl.setValue(self.freq_slider)
        self.col.setRed(self.freq)

    def freqEditChanged(self):
        globals.freq = float(self.freqEdit.text())
        self.freq.setValue(globals.freq)

    def setColor(self, pressed):
        
        source = self.sender()
        
        if pressed:
            val = 255
        else: val = 0
                        
        if source.text() == "Red":
            self.col.setRed(val)                
        elif source.text() == "Green":
            self.col.setGreen(val)             
        else:
            self.col.setBlue(val) 
            
        self.square.setStyleSheet("QFrame { background-color: %s }" %
            self.col.name())  
    
    def readMem(self):
        # Is the virtual LED on or off?

        #open memory
        mem = mmap.mmap(f.fileno(), 1000, offset=0x43c00000)

        #set register
        reg   = 0

        #seek to register
        mem.seek(reg)  
        mem.write(struct.pack('l', toMem))

        time.sleep(.5) 

        mem.seek(reg)  
        fromMem = struct.unpack('l', mem.read(4))[0] 
  
        # Print value (Need to write this to the Box for Blink, 1 or 0)
        print(str(reg) + " = " + str(fromMem))

        mem.close

    def writeMem(self, val):
        # Write frequency to memory from slider, pass in value from slider?

        #open memory
        mem = mmap.mmap(f.fileno(), 1000, offset=0x43c00000)

        #set register
        reg   = 4

        mem.seek(reg)  
        mem.write(struct.pack('l', val))

        time.sleep(.5) 

        mem.seek(reg)  
        fromMem = struct.unpack('l', mem.read(4))[0] 
  
        print(str(reg) + " = " + str(fromMem))
  
        mem.close()

def main():
    
    app = QtGui.QApplication(sys.argv)
    ex = Example()
    sys.exit(app.exec_())


if __name__ == '__main__':
    main()    