
$inputPath = $PSScriptRoot+"\input.csv"
$inputTable = Import-Csv -Path $inputPath
$sysDateTime = get-date -Format "dd-MM-yyyy HH-mm"
$outTablePath = $PSScriptRoot+"\TableResult"+$sysDateTime+".csv"
$textOutPath = $PSScriptRoot+"\TextResults"+ $sysDateTime +".txt"

$asset1cap = [decimal]$inputTable[0].UnitPrice * [decimal]$inputTable[0].UnitSupply
$asset2cap = [decimal]$inputTable[1].UnitPrice * [decimal]$inputTable[1].UnitSupply
$asset3cap = [decimal]$inputTable[2].UnitPrice * [decimal]$inputTable[2].UnitSupply

$msg= "PRICES @ DIFFERNET MARKET CAPs`n"
$msg= $msg + "===============================`n"
$msg= $msg + "Comparing assets against the following 3...`n"
$msg= $msg + $inputTable[0].AssetName + " Market Cap: " + $asset1cap +"`n"
$msg= $msg + $inputTable[1].AssetName + " Market Cap: " + $asset2cap +"`n"
$msg= $msg + $inputTable[2].AssetName + " Market Cap: " + $asset3cap +"`n"

write-host $msg
$msg | Add-Content -Path $textOutPath

$computeTable = New-Object System.Data.DataTable
$columns = @("Ticker","Price","Supply","MarketCap","PriceAtAsset1Cap","HowManyX1","PriceAtAsset2Cap","HowManyX2","PriceAtAsset3Cap","HowManyX3")
foreach($col in $columns)
{
    $holdOutput = $computeTable.columns.Add($col)
}

foreach($inasset in $inputTable)
{
    $row = $computeTable.NewRow()
    $row.Ticker = $inasset.AssetName
    $row.Price = [decimal]$inasset.UnitPrice
    $row.Supply = [decimal]$inasset.UnitSupply
    $row.MarketCap = [math]::Round([decimal]$row.Price * [decimal]$row.Supply,0)
    $row.PriceAtAsset1Cap = [math]::Round($asset1cap/$row.MarketCap * $row.Price,2)
    $row.HowManyX1 = [math]::Round($row.PriceAtAsset1Cap / $row.Price,2)
    $row.PriceAtAsset2Cap = [math]::Round($asset2cap/$row.MarketCap * $row.Price,2)
    $row.HowManyX2 = [math]::Round($row.PriceAtAsset2Cap / $row.Price,2)
    $row.PriceAtAsset3Cap = [math]::Round($asset3cap/$row.MarketCap * $row.Price,2)
    $row.HowManyX3 = [math]::Round($row.PriceAtAsset3Cap / $row.Price,2)

    $message = $row.Ticker + "-----------------------------`n"
    $message = $message + "`$" + $row.Price + "/" + $row.Ticker + " @ current MarketCap `n"
    $message = $message + "`$" + $row.PriceAtAsset1Cap + "/" + $row.Ticker + " @ " + $inputTable[0].AssetName + "'s MarketCap ("+$row.HowManyX1+"x)`n"
    $message = $message + "`$" + $row.PriceAtAsset2Cap + "/" + $row.Ticker + " @ " + $inputTable[1].AssetName + "'s MarketCap ("+$row.HowManyX2+"x)`n"
    $message = $message + "`$" + $row.PriceAtAsset3Cap + "/" + $row.Ticker + " @ " + $inputTable[2].AssetName + "'s MarketCap ("+$row.HowManyX3+"x)`n"
    write-host $message
    $message | Add-Content -Path $textOutPath
    $computeTable.Rows.Add($row)
}

$computeTable | Export-Csv -Path $outTablePath -NoTypeInformation