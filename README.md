# PRUsetup
Disclaimer: Very little of this content is originally mine. It is the result of piecing together guides and forum posts for various locations.


Driver Setup:

1. Device Tree Compiler
  This allows you to compile .dts files into .dtbo objects. .dtbo objects are used to enable pins and hardware on the beaglebone. Your    beaglebone may already have this but if not do,
    
      apt-get install device-tree-compiler

2. PRU Assembler (PASM)
  The purpose of PASM is to assemble the .p assembly files that are written for the PRU. Follow these steps to set it up
  
    a. Get a copy of the am335x_pru_package software from the GitHub repository https://github.com/beagleboard/am335x_pru_package.
    
    b. Make a new directory /usr/include/pruss/ and copy the files prussdrv.h  and pruss_intc_mapping.h into it (from am335x_pru_package-master/pru_sw/app_loader/include).
    
    c. Change directory to am335x_pru_package-master/pru_sw/app_loader/interface then run: CROSS_COMPILE= make (note the space between the = and the command).
    
    d. The previous step should have created four files in am335x_pru_package-master/pru_sw/app_loader/lib: libprussdrv.a, libprussdrvd.a, libprussdrvd.so and libprussdrv.so. Copy these all to /usr/lib then run ldconfig.
    
    e. Change directory to am335x_pru_package-master/pru_sw/utils/pasm_source then run "source linuxbuild" to create a pasm executable one directory level up. Copy it to /usr/bin and make sure you can run it. If you invoke it with no arguments, you should get a usage statement.
    
3. Enable PRU
  This may already be possible depending on the image of your Beaglebone
  a. Go to https://github.com/RobertCNelson/bb.org-overlays and make sure you have these overlays, I had to install them but some images apparently have them by default. Follow the instructions in the README. This involves changes to the kernel that are very necessary and most people seem to suggest that most beaglebones have these already.
  
  b. To get the basic device tree overlays that can be used to enable the PRUs, get this repo: https://github.com/cdsteinkuehler/beaglebone-universal-io. This also allows the use of "config-pin" command. Use the following command for more information.
  
      config-pin help

  c. If you have done everything properly up until now, you should be able to enable the PRU's with:
  
      echo cape-universala > /sys/platform/devices/bone_capemgr/slots
     
     Check if it exported by typing:
     
      cat /sys/platform/devices/bone_capemgr/slots
      
      Note that nearly all guides were written for the 3.8 kernel. The path for /slots changed with kernel 4.0.

  
