<?php



/*
>>>>> utf-8 >>>> utf-8 Eau pulvérisée Avec Antigel - Classes AB
>>>>> windows-1250 >>>> windows-1250 Eau pulvérisée Avec Antigel - Classes AB
>>>>> ISO-8859-15 >>>> ISO-8859-15 Eau pulvérisée Avec Antigel - Classes AB
>>>>> ISO-8859-15 >>>> ISO-8859-1 Eau pulvérisée Avec Antigel - Classes AB
>>>>> ISO-8859-1 >>>> ISO-8859-15 Eau pulvérisée Avec Antigel - Classes AB
>>>>> ISO-8859-1 >>>> ISO-8859-1 Eau pulvérisée Avec Antigel - Classes AB
>>>>> CP1256 >>>> CP1256 Eau pulvérisée Avec Antigel - Classes AB

$tab = array("utf-8", "ASCII", "windows-1250", "ISO-8859-15", "ISO-8859-1", "ISO-8859-6", "CP1256");
$chain = "Eau pulvérisée Avec Antigel - Classes AB";

$result =  $chain ."\n";

foreach ($tab as $i)
    {
        foreach ($tab as $j)
        {
            $result .= "\n>>>>> $i >>>> $j " . iconv($i, $j, $chain) ."\n";
        }
    }

echo $result;

return;
*/

function utf8_fopen_read($fileName) {

//    $fc = iconv('windows-1250', 'utf-8', file_get_contents($fileName));
    $fc = iconv("ISO-8859-15", 'ISO-8859-1', file_get_contents($fileName));


    $handle=fopen("php://memory", "rw");
    fwrite($handle, $fc);
    fseek($handle, 0);
    return $handle;
}



$array = $fields = array(); $i = 0;
$sql1 =  "";
$sql2 =  "";
$sql3 =  "";
$sql4 =  "";
$tableName = "Articles_Ebp";
//$tableName = "ArticlesImg_Ebp";
$handle = @fopen("Ebp/" . $tableName .".csv", "r");

if ($handle) {

    if (str_contains($tableName, "Img_"))
    {
    
        $csvs = [];
        while(! feof($handle)) {
            $csvs[] = fgetcsv($handle, null, ";");
        }
    
        $column_names = [];
    
        foreach ($csvs[0] as $single_csv) {
            $single_csv = preg_replace('/[\x00-\x1F\x80-\xFF]/', '', $single_csv);
            $column_names[] = $single_csv;
        }

    
    
    foreach ($csvs as $key => $csv) {
        if ($key === 0) {
            continue;
        }

        if (empty($csv[0]))
            {
            break;
            }
    
        $DestFile = "Img/" . $tableName . "_" . $csv[0] . ".jpg";
        $data = base64_decode($csv[1]);
        file_put_contents($DestFile, $data);

        echo $DestFile . "\n";
//        echo $csv[1] . "\n";

        
        
        
        
    }
        
        echo "Fin Img";
}
    else
    {
     
        $co = mysqli_connect("localhost", "Ted88300", "Zzt88300", "VerifPlus");

        mysqli_set_charset($co, "utf8");
        $response = array();
        $response["success"] = -1;

        if (mysqli_connect_errno())
            {
            echo "Failed to connect to MySQL: " . mysqli_connect_error();
            }
        else
            {

        
        
        $csvs = [];
        while(! feof($handle)) {
           $csvs[] = fgetcsv($handle, null, ";");
        }

        $sql1 = "INSERT INTO " . $tableName ." ( ";
        $column_names = [];

        $sql2 = "";
        $c = 0;
        foreach ($csvs[0] as $single_csv) {
            if (!empty($sql3))
                {
                    $sql2 .= ", ";
                }
            $single_csv = preg_replace('/[\x00-\x1F\x80-\xFF]/', '', $single_csv);
            $column_names[] = $single_csv;
            $sql2 .= $single_csv;
            $c++;
            
        }

        $sql1 .= $sql2 . ") VALUE ";
        

                $sql4 = $sql1;
        foreach ($csvs as $key => $csv) {
            if ($key === 0) {
                continue;
            }
            $sql3 = "";
            foreach ($column_names as $column_key => $column_name) {

                if (empty($csv[0]))
                    {
                        break;                }
                
                if (!empty($sql3))
                    {
                        $sql3 .= ", ";
                    }

                if (str_starts_with($column_names[$column_key], 's'))
                    {
                        $wTmp = str_replace('"', '“', $csv[$column_key]);

                        $sql3 .= '"';
                        $sql3 .= $wTmp;
                        $sql3 .= '"';

                    }
                else if (str_starts_with($column_names[$column_key], 'd'))
                    {
                        $sql3 .= str_replace(',', '.', $csv[$column_key]);


                    }
                else
                    $sql3 .=  $csv[$column_key];
            }

            if (!empty($sql3))
                {
                    $sql4 .=  "( " . $sql3 . " );";
                }

                }
        
                echo $sql4;
//        $sql1 .= $sql4;

                }
                
//                echo $sql1;
                
    }
    fclose($handle);
 
//    print_r($csvs);
    
}
else
{
    echo "Error: File not found \n";

}


?>
