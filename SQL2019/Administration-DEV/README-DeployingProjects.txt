Deploying VS 2017/SSDT 2017 Packages
--known issues with Microsoft prevent deploying VS/SSDT 2017 packages using the deployment options within a package
--projects and packages cannot be deployed by right clicking an object and using the Deploy option in the menu
--Deploying 2017 projects is a two step process using the ISDeploymentWizard tool
1) Save the project, right click the project and select Build
2) If the build succeeds, an .ispac file (a project deployment file) is created in the Bin folder in the project's workspace (a subfolder of the project Build > Configuration used contains the .ispac file)
3) Navigate to the ISDeploymentWizard.exe and run (as Administrator may be needed).  The deployment wizard is in the Microsoft SQL Server\DTS\Binn folder which could be in either Program Files or Program Files (x86) paths.
4) In the GUI, select the .ispac file created and complete the deployment values (Server, Project, etc.) that would appear if the deployment