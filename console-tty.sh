echo “ttyS0″ >> /etc/securetty
echo "add this to your kernel params \"console=ttyS0\"
echo "S0:12345:respawn:/sbin/agetty ttyS0 115200" >> /etc/inittab 

