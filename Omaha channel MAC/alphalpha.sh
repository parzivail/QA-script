#displaying message to user

printf 	"
	 THIS SCRIPT WILL ENABLE YOUR DEVICE TO DOWNLOAD INTERNAL ALPHA RELEASES
	 THIS SCRIPT AND THE INFORMATION WITHIN IS CONFIDENTIAL AND SHALL NOT BE SHARED WITH OTHERS

	 Make sure your device is connected to your computer via USB.
	 You might have to wait 2 minutes for the connection to be up and running.

	 When you are prompted if you want to continue, type yes and press enter.

	 You will have to enter the device's password.
	 You can find this in Settings -> About (scroll down the right hand panel).
	 The password usually looks something like this: ‘2fO4WwYc9Q’.
	
	 Close this window now if you want to exit without changes being made.\n\n"

#remove conflicting SSH aliases
cd
rm -rf ~/.ssh/known_hosts

#remove existing APPID and GROUP. ADD new APPID and GROUP.
ssh root@10.11.99.1	 "sed -i '/REMARKABLE_RELEASE_VERSION=/d' /usr/share/remarkable/update.conf &&
			  sed -i '2s;^;REMARKABLE_RELEASE_VERSION=1.9.0.0\n;' /usr/share/remarkable/update.conf &&
			  sed -i '/REMARKABLE_RELEASE_APPID=/d' .config/remarkable/xochitl.conf && 
			  sed -i '/GROUP=/d' .config/remarkable/xochitl.conf &&
			  sed -i '2s;^;GROUP=alpha\n REMARKABLE_RELEASE_APPID={C1D98898-2581-4B10-8512-7F5E20DAB811}\n;' .config/remarkable/xochitl.conf &&

			  /sbin/reboot"

#displaying message to user
printf	"
	 !----------------------------------------!
         !  AFTER REBOOT TRY TO CHECK FOR UPDATE  !
         !----------------------------------------!\n\n"


