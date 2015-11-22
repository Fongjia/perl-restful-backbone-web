use Data::Dumper;
use XML::Simple;
use Dancer;
use POSIX;
#set serializer => 'XML';
set serializer => 'JSON'; #un-comment this for json format responses

get '/' => sub{
    return {message => "First rest Web Service with Perl and Dancer"};
};

# get total cl number and test status waiting, running, finish
get '/cl' => sub{
    my $dirname = "../../log";
    opendir my($dh), $dirname or die "Couldn't open dir '$dirname': $!";
    my @files = readdir $dh;
    closedir $dh;
    my %CLlist;
    my %CL;
    for(my $i = 0;$i < scalar(@files) ; $i++)
    {
        if(isdigit($files[$i]))
        {
            my $xml = new XML::Simple();
            my $testplane = $xml->XMLin("../../log/$files[$i]/testplane.xml",SuppressEmpty => '', KeyAttr => {});
            my $status = "finish";
            if($testplane->{StartTime} ne "" && $testplane->{FinishTime} eq "")
            {
                $status = "running";
            }
            elsif($testplane->{StartTime} eq "" && $testplane->{FinishTime} eq "")
            {
                $status = "waiting";
            }
            $CLlist{$files[$i]} = {status => "$status", StartTime => $testplane->{StartTime}, FinishTime => $testplane->{FinishTime}};
        }
    };
    $CL{"CL"} = {%CLlist};
    return \%CL;
};

# get test detail report by cl number
get '/cl/:number' => sub {
    my $number = params->{number};
    my $xml = new XML::Simple();
    my $testplane = $xml->XMLin("../../log/$number/testplane.xml",SuppressEmpty => '', KeyAttr => {});
    return $testplane;
};

dance;