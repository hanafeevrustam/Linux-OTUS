groupadd admgrp

useradd testuser
usermod -a -G admgrp testuser

sed -i '5i\account required pam_time.so' /etc/pam.d/login
sed -i '4i\account required pam_time.so' /etc/pam.d/sshd



cat >> /etc/security/time.conf << EOF
login ; tty* & !ttyp* ; !admgrp ; Wd
sshd ;  tty* & !ttyp* ; !admgrp ; Wd
EOF