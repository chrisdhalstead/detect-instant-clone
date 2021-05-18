<#
.SYNOPSIS
Script to detect if VM is an Instant Clone
	
.NOTES
  Version:        1.0
  Author:         Chris Halstead - chalstead@vmware.com
  Creation Date:  5/18/2021
  Purpose/Change: Initial Script

  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL 
  VMWARE,INC. BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
  IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
  CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
  
 #>

if (Test-Path -Path 'HKLM:\SOFTWARE\VMware, Inc.\Installer\Features_HorizonAgent')

{

  Write-Host "Horizon Agent Detected"
  $isIC = Get-ItemProperty -Path 'HKLM:\SOFTWARE\VMware, Inc.\Installer\Features_HorizonAgent' -Name "NGVC"

  if ($isic.NGVC -eq "Local")

  {
    Write-Host "Instant Clone Engine Installed"
   
    if (Test-Path -Path 'HKLM:\SOFTWARE\VMware, Inc.\ViewComposer\nga')
    
    {
      If (Get-ItemProperty -Path 'HKLM:\SOFTWARE\VMware, Inc.\ViewComposer\nga' -Name "VmForked" -ErrorAction SilentlyContinue) 
      
      {

        $ic = Get-ItemProperty -Path 'HKLM:\SOFTWARE\VMware, Inc.\ViewComposer\nga' -Name 'VmForked'
        if($ic.VmForked -eq "1")
    
        {

          Write-Host "VM is an Instant Clone"

          If (Get-ItemProperty -Path 'HKLM:\SOFTWARE\VMware, Inc.\ViewComposer\nga' -Name "ParentCustStartTimeSet" -ErrorAction SilentlyContinue) 
          {

            Write-Host "VM is an Instant Clone with a ParentVM (Mode A)"

          }
          else 
          {
           
            Write-Host "VM is an Instant Clone without a ParentVM (Mode B)"

          }
       
        }
    
      } 
    
    Else
     {
    
        Write-Host "VM is NOT an Instant Clone"
        Break
      } 
   

    }

}

}

else
 {
  
 Write-Host "Horizon Agent Not Detected"
 break

 }