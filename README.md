# Hi there, I'm Jorge

```powershell
<#
.SYNOPSIS
Senior IT Systems Engineer with expertise in automation, cross-platform device management,
and infrastructure engineering. Focused on Intune, SCCM, PowerShell, and cloud-first strategies
for scale, security, and simplicity.
#>

# PERSONAL INFORMATION
$Info = [PSCustomObject]@{
    Name        = 'Jorge Suarez'
    Title       = 'Senior IT Systems Engineer'
    Email       = 'jorge2990@live.com'
    Location    = 'Greater Seattle Area'
    LinkedIn    = 'https://www.linkedin.com/in/jorgeasaurus'
    GitHub      = 'https://github.com/jorgeasaurus'
    Blog        = 'https://jorgeasaur.us'
}

# Latest Projects
$Projects = @{
    "Intune-Snapshot-Recovery"  = "$($Info.GitHub)/Intune-Snapshot-Recovery"
    "JamfAssignmentChecker"     = "$($Info.GitHub)/JamfAssignmentChecker"
}

# PLATFORMS
$Platforms = @('Windows', 'macOS', 'Linux', 'iOS', 'Android')

# LANGUAGES
$Languages = @('PowerShell', 'Bash')

# TOOLS & TECHNOLOGIES
$Tools = @(
    'Microsoft Intune', 'SCCM/MECM', 'Azure AD', 'Jamf Pro',
    'Microsoft Graph API', 'Jira', 'Confluence', 'Bitbucket', 'GitHub', 'Jenkins',
    'Power BI', 'Splunk'
)

# CERTIFICATIONS
$Certifications = @(
    'Microsoft 365 Certified: Administrator Expert'
    'Microsoft 365 Certified: Endpoint Administrator Associate',
    'Jamf 200 Certified Tech'
)

# LANGUAGES SPOKEN
$SpokenLanguages = [PSCustomObject]@{
    English = 'Native/Bilingual'
    Spanish = 'Native/Bilingual'
}

# WORK EXPERIENCE
$Experience = @(
    [PSCustomObject]@{
        Company     = 'SpaceX'
        Role        = 'Senior IT Systems Engineer'
        Period      = 'Apr 2024 - Present'
        Highlights  = @(
            'Automated packaging for 50+ Windows apps, saving $500K annually',
            'Created custom app request workflow for Jamf and Intune',
            'Built Intune rollout dashboards via PowerShell + Graph + Jenkins',
            'Automated SCCM cleanup to avoid storage outages',
            'Implemented MDM cert renewal alerts to prevent device loss',
            'Developed Azure dynamic group emulation for filtering gaps'
        )
    },
    [PSCustomObject]@{
        Company     = 'SpaceX'
        Role        = 'IT Systems Engineer'
        Period      = 'Apr 2020 - Apr 2024'
        Highlights  = @(
            'Automated application lifecycle in SCCM using Jenkins and PowerShell',
            'Deployed Intune MDM with advanced security policies',
            'Integrated Graph API and Jenkins for cloud orchestration'
        )
    },
    [PSCustomObject]@{
        Company     = 'Jabil'
        Role        = 'Systems Engineer (Intune/SCCM)'
        Period      = 'Mar 2019 - Apr 2020'
        Highlights  = @(
            'Led endpoint M&A rollout across US and Europe (3000+ devices)',
            'Reduced provisioning time by 80% with PowerShell and SCCM',
            'Built auditing GUI that cut audit time by 90%'
        )
    },
    [PSCustomObject]@{
        Company     = 'Jabil'
        Role        = 'Programmer Analyst I'
        Period      = 'May 2018 - Mar 2019'
        Highlights  = @(
            'Provisioned Docker EE infra with VSTS CI/CD',
            'Integrated AWS/Azure hybrid deployments',
            'Built monitoring stack using Prometheus & Grafana'
        )
    },
    [PSCustomObject]@{
        Company     = 'Jabil'
        Role        = 'Desktop Support Technician II'
        Period      = 'May 2017 - May 2018'
        Highlights  = @(
            'Supported 400+ users with SCCM imaging and automation',
            'Reduced SLA breaches with scripting automations',
            'Participated in on-call rotation and user training'
        )
    },
    [PSCustomObject]@{
        Company     = 'Synergy Technology Solutions LLC'
        Role        = 'IT Support Technician Level 2'
        Period      = 'Apr 2016 - Apr 2017'
        Highlights  = @(
            'Monitored and supported 35+ client networks',
            'Maintained backup/recovery systems and change requests',
            'Led troubleshooting for network and software issues'
        )
    }
)

# EDUCATION
$Education = @(
    [PSCustomObject]@{
        Institution = 'Hillsborough Community College'
        Degree      = 'Associate of Science'
        Focus       = 'Network Administration'
        Period      = '2016-2019'
    },
    [PSCustomObject]@{
        Institution = 'Hillsborough High School'
        Degree      = 'High School Diploma (with Honors)'
        Period      = '2006-2009'
    }
)
```
