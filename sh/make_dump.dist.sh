cd /tmp
mysqldump -u {DBusr} -p{DBpswd} {DBname} > dump.sql
rar a dump.rar dump.sql