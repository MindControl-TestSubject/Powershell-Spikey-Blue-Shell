#######################################################################
#   Author: Evan Brown                                                #
#   Date: 26-12-2018                                                  #
#   Description:                                                      #
#      Used to enter a line at the top of an excel doc.               #
#      Same concept can be used for any excel document.               #
#      It is much easier to add a line to the top of the doc than it  #
#      is to search each row to see which one is completely empty,    #
#      especially with large files.                                   #
#                                                                     #
#######################################################################

param(
    [Parameter(Position=0)][String]$Description,
    [Parameter(Position=1)][String]$IMEI,
    [Parameter(Position=2)][String]$OrderNo,
    [Parameter(Position=3)][String]$LocationCode,
    [Parameter(Position=4)][DateTime]$PurchaseDate
)

$excel_file_path = '\\VIRFS01\share\ITResources\Documentation\Cell Phone-Phone Setup\Proof_of_Purchase.xlsx'
## Instantiate the COM object
$Excel = New-Object -ComObject Excel.Application
$ExcelWorkBook = $Excel.Workbooks.Open($excel_file_path)
$ExcelWorkSheet = $Excel.WorkSheets.item(1)
$ExcelWorkSheet.activate()

# Insert a new row right below the headers
$eRow = $ExcelWorkSheet.Cells.Item(2,2).EntireRow
$Active = $eRow.Activate()
$Active = $eRow.Insert(-4121)

# Put the entered info into that new row
$ExcelWorkSheet.Cells.Item(2,1) = $Description
$ExcelWorkSheet.Cells.Item(2,2) = $IMEI
$ExcelWorkSheet.Cells.Item(2,3) = $OrderNo
$ExcelWorkSheet.Cells.Item(2,4) = $LocationCode
$ExcelWorkSheet.Cells.Item(2,5) = $PurchaseDate
 
$ExcelWorkBook.Save()
$ExcelWorkBook.Close()
$Excel.Quit()
[System.Runtime.Interopservices.Marshal]::ReleaseComObject($Excel) > $null
Stop-Process -Name EXCEL -Force > $null