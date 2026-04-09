[CmdletBinding(SupportsShouldProcess)]
param(
    [string]$ModulePath = '/Users/jorgeasaurus/Code/MicrosoftMvp/MicrosoftMvp.psd1',
    [switch]$UseDefaultBrowser
)

$ErrorActionPreference = 'Stop'

if (-not (Test-Path -LiteralPath $ModulePath)) {
    throw "MicrosoftMvp module path not found: $ModulePath"
}

$hasMvpCmdlets = $null -ne (Get-Command -Name New-MvpActivity -ErrorAction SilentlyContinue)
if (-not $hasMvpCmdlets) {
    Import-Module -Name $ModulePath -ErrorAction Stop
}

if (-not (Get-Command -Name New-MvpActivity -ErrorAction SilentlyContinue)) {
    throw 'MicrosoftMvp module cmdlets failed to load. Restart PowerShell and run the script again.'
}

Connect-Mvp -UseDefaultBrowser:$UseDefaultBrowser

# Selected based on current featured projects + merged PRs, engagement, and expected community impact.
$selectedActivities = @(
    [pscustomobject]@{
        Title                      = 'GraphExplorerPlus'
        Description                = 'Power-user alternative to Microsoft Graph Explorer with curated request samples, permission insights, and code snippets in multiple languages.'
        Url                        = 'https://github.com/jorgeasaurus/graphexplorerplus'
        TechnologyFocusArea        = 'Microsoft Graph'
        TargetAudience             = @('IT Pro', 'Developer', 'Technical Decision Maker')
        AdditionalTechnologyAreas  = @('PowerShell')
        Date                       = (Get-Date '2026-04-08')
    }
    [pscustomobject]@{
        Title                      = 'ErrorIndex'
        Description                = 'Searchable reference for Microsoft error codes across Entra ID, Microsoft Graph, Intune, SCCM, Exchange, and Windows to reduce troubleshooting time.'
        Url                        = 'https://github.com/jorgeasaurus/errorindex'
        TechnologyFocusArea        = 'Microsoft Graph'
        TargetAudience             = @('IT Pro', 'Developer', 'Technical Decision Maker')
        AdditionalTechnologyAreas  = @('Microsoft Intune', 'PowerShell')
        Date                       = (Get-Date '2026-04-08')
    }
    [pscustomobject]@{
        Title                      = 'WingetIntunePublisher'
        Description                = 'PowerShell module for automating WinGet app packaging and publishing into Microsoft Intune with repeatable, script-first workflows.'
        Url                        = 'https://github.com/jorgeasaurus/WingetIntunePublisher'
        TechnologyFocusArea        = 'Microsoft Intune'
        TargetAudience             = @('IT Pro', 'Developer')
        AdditionalTechnologyAreas  = @('PowerShell')
        Date                       = (Get-Date '2026-03-15')
    }
    [pscustomobject]@{
        Title                      = 'WinStoreRip'
        Description                = 'PowerShell tool to query and download Microsoft Store app packages from the command line for Windows-focused admin and packaging workflows.'
        Url                        = 'https://github.com/jorgeasaurus/WinStoreRip'
        TechnologyFocusArea        = 'PowerShell'
        TargetAudience             = @('IT Pro', 'Developer')
        AdditionalTechnologyAreas  = @('Microsoft Intune')
        Date                       = (Get-Date '2026-03-15')
    }
    [pscustomobject]@{
        Title                      = 'Intune Hydration Kit Web App'
        Description                = 'Web app companion for Intune Hydration Kit focused on Graph-powered import workflows, hardened API handling, and easier onboarding for Intune automation scenarios.'
        Url                        = 'https://github.com/jorgeasaurus/IntuneHydrationKit-WebApp'
        TechnologyFocusArea        = 'Microsoft Intune'
        TargetAudience             = @('IT Pro', 'Developer', 'Technical Decision Maker')
        AdditionalTechnologyAreas  = @('Microsoft Graph', 'PowerShell')
        Date                       = (Get-Date '2026-02-03')
    }
    [pscustomobject]@{
        Title                      = 'Merged PR: intune-my-macs Remote Help download fix'
        Description                = 'Merged pull request that fixes Remote Help installation script download logic in microsoft/intune-my-macs, improving reliability for Intune macOS admin workflows.'
        Url                        = 'https://github.com/microsoft/intune-my-macs/pull/9'
        TechnologyFocusArea        = 'Microsoft Intune'
        TargetAudience             = @('IT Pro', 'Developer')
        AdditionalTechnologyAreas  = @('PowerShell')
        Date                       = (Get-Date '2026-02-02')
        EndDate                    = (Get-Date '2026-03-11')
    }
    [pscustomobject]@{
        Title                      = 'Merged PR: MicrosoftMvp browser auth + additionalTechnologyAreas'
        Description                = 'Merged pull request to the MicrosoftMvp module adding cross-platform OAuth2 browser authentication flow and support for additionalTechnologyAreas when creating activities.'
        Url                        = 'https://github.com/JustinGrote/MicrosoftMvp/pull/3'
        TechnologyFocusArea        = 'PowerShell'
        TargetAudience             = @('IT Pro', 'Developer')
        AdditionalTechnologyAreas  = @('Microsoft Graph', 'Microsoft Intune')
        Date                       = (Get-Date '2026-02-08')
        EndDate                    = (Get-Date '2026-02-22')
    }
    [pscustomobject]@{
        Title                      = 'Merged PR: Graph XRay PowerShell snippet fallback'
        Description                = 'Merged pull request to Graph XRay improving PowerShell snippet fallback behavior, helping admins and developers execute Graph queries more reliably.'
        Url                        = 'https://github.com/merill/graphxray/pull/11'
        TechnologyFocusArea        = 'Microsoft Graph'
        TargetAudience             = @('IT Pro', 'Developer')
        AdditionalTechnologyAreas  = @('PowerShell')
        Date                       = (Get-Date '2026-04-04')
        EndDate                    = (Get-Date '2026-04-04')
    }
    [pscustomobject]@{
        Title                      = 'Merged PR: Graph XRay Firefox support'
        Description                = 'Merged pull request to Graph XRay adding Firefox browser support, expanding Microsoft Graph troubleshooting accessibility across browsers.'
        Url                        = 'https://github.com/merill/graphxray/pull/4'
        TechnologyFocusArea        = 'Microsoft Graph'
        TargetAudience             = @('IT Pro', 'Developer')
        AdditionalTechnologyAreas  = @('PowerShell')
        Date                       = (Get-Date '2025-10-04')
        EndDate                    = (Get-Date '2026-04-05')
    }
)

$existingActivities = Get-MvpActivity -First 10000

foreach ($candidate in $selectedActivities) {
    $isDuplicate = $existingActivities | Where-Object {
        $_.url -eq $candidate.Url -or $_.title -eq $candidate.Title
    }

    if ($isDuplicate) {
        Write-Host "Skipping existing activity: $($candidate.Title)"
        continue
    }

    $newActivityParams = @{
        Title                     = $candidate.Title
        Description               = $candidate.Description
        Type                      = 'Open Source/Project/Sample code/Tools'
        TechnologyFocusArea       = $candidate.TechnologyFocusArea
        TargetAudience            = $candidate.TargetAudience
        AdditionalTechnologyAreas = $candidate.AdditionalTechnologyAreas
        Quantity                  = 1
        Reach                     = 0
    }

    if ($null -ne $candidate.PSObject.Properties['Date'] -and $null -ne $candidate.Date) {
        $newActivityParams.Date = $candidate.Date
    }

    if ($null -ne $candidate.PSObject.Properties['EndDate'] -and $null -ne $candidate.EndDate) {
        $newActivityParams.EndDate = $candidate.EndDate
    }

    $newMvpActivity = New-MvpActivity @newActivityParams

    $newMvpActivity.url = $candidate.Url

    if ($PSCmdlet.ShouldProcess($candidate.Title, 'Add MVP activity')) {
        $created = Add-MvpActivity -Activity $newMvpActivity
        Write-Host "Added activity: $($created.title) (Id: $($created.id))"
    }
}