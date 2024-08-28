namespace LoadFileInZBrush
{
    class Program
    {
        static void Main(string[] args)
        {
            if (args.Length == 0 || args[0] == “?” || args[0] == “help”)
                {
                    Console.Out.WriteLine(“LoadScript Help:”);
                    Console.Out.WriteLine(“syntax: LoadScript.exe [Full Path to file]”);
                    Console.Out.WriteLine(“example: LoadScript.exe “C:\users\default\Desktop\myScript.zsc””);
                    return;
                }
            FileInfo fileToLoad = new FileInfo(args[0]);
            DirectoryInfo zbrushExeDirectory = new DirectoryInfo(FindZBrushWorkingDir());
            if (fileToLoad.Extension.ToUpper() == “.ZTL” || fileToLoad.Extension.ToUpper() == “.TXT” || fileToLoad.Extension.ToUpper() == “.ZSC”)
            {
                if (fileToLoad.Exists && zbrushExeDirectory.Exists) 
                {
                    Process p = new Process(); p.StartInfo.RedirectStandardError = true; p.StartInfo.RedirectStandardOutput = true; p.StartInfo.UseShellExecute = false; p.StartInfo.FileName = zbrushExeDirectory.FullName + "ZBrush.exe"; p.StartInfo.Arguments = fileToLoad.FullName; p.OutputDataReceived += new DataReceivedEventHandler( (s, e) =&gt; { Console.Out.WriteLine(e.Data); } ); p.ErrorDataReceived += new DataReceivedEventHandler((s, e) =&gt; { Console.Error.WriteLine(e.Data); }); p.Start(); p.BeginOutputReadLine(); p.BeginErrorReadLine(); p.WaitForExit(); 
                } 
                else 
                { 
                    if (!fileToLoad.Exists) 
                    { 
                        Console.Error.WriteLine(String.Format("{0} not found.", args[0])); 
                    } 
                    if (!zbrushExeDirectory.Exists) 
                    { 
                        Console.Error.WriteLine(String.Format("{0} not found.", args[0])); 
                    } 
                } 
            } 
            else 
            { 
                Console.Error.WriteLine("File must be a .ZTL, .TXT, or .ZSC"); return; 
            } 

        } 
        private static string FindZBrushWorkingDir() 
        { 
            List<string> zbrushAppNames = new List<string>(); string registryKey = @"SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall"; 
            try 
            { 
                
                using (RegistryKey key = Registry.LocalMachine.OpenSubKey(registryKey)) 
                { 
                    foreach (string subkeyName in key.GetSubKeyNames()) 
                    { 
                        using (RegistryKey subkey = key.OpenSubKey(subkeyName)) 
                        { //Console.WriteLine(subkey.GetValue("DisplayName")); object objName = subkey.GetValue("DisplayName"); object objVers = subkey.GetValue("DisplayVersion"); object objInstallPath = subkey.GetValue("InstallLocation"); if (objName != null && objVers != null) 
                        { string name = objName.ToString(); string version = objVers.ToString(); 
                            if (name.Contains("ZBrush")) 
                            { zbrushAppNames.Add(objInstallPath.ToString()); } } 
                        } 
                    } 
                } 
                //return the latest version 
                return (zbrushAppNames.Last&lt;string&gt;() + "\\"); 
            } 
            catch(Exception e) 
            { 
                Console.Error.WriteLine(e.Message); return null; 
            } 
        } 
    }
}
