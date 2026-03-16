CC      = gcc
CFLAGS  = -O2 -Wall -I/boot/include/redpitaya
LIBS    = -L/boot/lib -Wl,-rpath,/boot/lib -lrp -lm -lpthread
TARGET  = rp_pll

all: $(TARGET)

$(TARGET): rp_pll.c
	$(CC) $(CFLAGS) -o $(TARGET) rp_pll.c $(LIBS)

clean:
	rm -f $(TARGET)

.PHONY: all clean
