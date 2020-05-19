
:displaying message to user
@echo off
echo THIS SCRIPT WILL ENABLE YOUR DEVICE TO DOWNLOAD INTERNAL BETA RELEASES
echo THIS SCRIPT AND THE INFORMATION WITHIN IS CONFIDENTIAL AND SHALL NOT BE SHARED WITH OTHERS
echo make sure your device is connected to the pc
echo close this window now if you want to exit without changes being made
@pause


:removing keys and testing if ssh tools are installed
ssh-keygen -R 10.11.99.1

:editing config file
ssh root@10.11.99.1		"sed -i '/REMARKABLE_RELEASE_APPID=/d' .config/remarkable/xochitl.conf && sed -i '/GROUP=/d' .config/remarkable/xochitl.conf &&	sed -i '2s;^;GROUP=Prod\nREMARKABLE_RELEASE_APPID={C1D98898-2581-4B10-8512-7F5E20DAB811}\n;' .config/remarkable/xochitl.conf &&	/sbin/reboot"



:displaying message to user
echo              !---------------------------------------!
echo              !     YOUR DEVICE SHOULD NOW REBOOT     !
echo              !  AFTER REBOOT TRY TO DOWNLOAD UPDATE  !
echo              !---------------------------------------!

@pause


