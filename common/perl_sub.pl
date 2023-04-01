# use perl

sub runPipedCmd
{
   my(@paramArr) = @_ ;
   my $retCode;
   my $script;
   my $count;


    if($#paramArr == -1) {
       die ("runPipedCommand must be passed atlease one argument");
   }

   $script = $paramArr[0];
   print "Running:\n$script\n";
   if($#paramArr == 0) {
      print "here1";
      $retCode = runSystemCmd($script);
   }
   else {
      print "herr2";
      open(cmdPipe, "| $script");
      for ($count=1; $count<=$#paramArr; $count++) {
          print(cmdPipe $paramArr[$count]."\n");
      }
      close(cmdPipe);
      $retCode= $?;
      if ($retCode != 0) {
        $retCode = $? >> 8;
      }
   }
   return $retCode;
 }