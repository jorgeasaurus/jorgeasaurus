[CmdletBinding(SupportsShouldProcess)]
param(
    [string]$ModulePath = '/Users/jorgeasaurus/Code/MicrosoftMvp/MicrosoftMvp.psd1',
    [string]$ActivitiesJsonPath = '/Users/jorgeasaurus/Code/_jorgeasaurus/MVPActivities.json',
    [switch]$UpdateExisting,
    [switch]$ForceReconnect,
    [switch]$UseDefaultBrowser
)

$ErrorActionPreference = 'Stop'

if (-not (Test-Path -LiteralPath $ModulePath)) {
    throw "MicrosoftMvp module path not found: $ModulePath"
}

# Import from the expected path, but avoid unnecessary re-imports in the same session.
$resolvedModulePath = (Resolve-Path -LiteralPath $ModulePath).Path
$loadedMvpModule = Get-Module -Name MicrosoftMvp -ErrorAction SilentlyContinue | Select-Object -First 1

if ($null -eq $loadedMvpModule) {
    Import-Module -Name $resolvedModulePath -ErrorAction Stop
}
else {
    $loadedModulePath = if ($loadedMvpModule.Path) { (Resolve-Path -LiteralPath $loadedMvpModule.Path).Path } else { '' }
    if ($loadedModulePath -ne $resolvedModulePath) {
        Remove-Module -Name MicrosoftMvp -Force -ErrorAction SilentlyContinue
        Import-Module -Name $resolvedModulePath -ErrorAction Stop
    }
}

if (-not (Get-Command -Name New-MvpActivity -ErrorAction SilentlyContinue)) {
    throw 'MicrosoftMvp module cmdlets failed to load. Restart PowerShell and run the script again.'
}

if (-not (Test-Path -LiteralPath $ActivitiesJsonPath)) {
    throw "Activities JSON path not found: $ActivitiesJsonPath"
}

$activitySource = Get-Content -LiteralPath $ActivitiesJsonPath -Raw | ConvertFrom-Json

$selectedActivities = $activitySource | ForEach-Object {
    $startDate = $null
    $endDate = $null

    if ($null -ne $_.date -and -not [string]::IsNullOrWhiteSpace([string]$_.date)) {
        $startDate = Get-Date $_.date
    }

    if ($null -ne $_.dateEnd -and -not [string]::IsNullOrWhiteSpace([string]$_.dateEnd)) {
        $endDate = Get-Date $_.dateEnd
    }

    [pscustomobject]@{
        Id                        = if ($null -eq $_.PSObject.Properties['id'] -or $null -eq $_.id) { $null } else { [int]$_.id }
        Title                     = [string]$_.title
        Description               = [string]$_.description
        Url                       = [string]$_.url
        Type                      = if ([string]::IsNullOrWhiteSpace([string]$_.activityTypeName)) { 'Open Source/Project/Sample code/Tools' } else { [string]$_.activityTypeName }
        TechnologyFocusArea       = [string]$_.technologyFocusArea
        TargetAudience            = @($_.targetAudience)
        AdditionalTechnologyAreas = @($_.additionalTechnologyAreas)
        HasPrivateDescription     = $null -ne $_.PSObject.Properties['privateDescription']
        PrivateDescription        = [string]$_.privateDescription
        Role                      = [string]$_.role
        ContributionRoleLocKey    = [string]$_.contributionRoleLocKey
        Quantity                  = if ($null -eq $_.PSObject.Properties['quantity']) { $null } elseif ($null -eq $_.quantity -or [int]$_.quantity -lt 1) { 1 } else { [int]$_.quantity }
        Reach                     = if ($null -eq $_.PSObject.Properties['reach']) { $null } elseif ($null -eq $_.reach) { 0 } else { [int]$_.reach }
        InPersonAttendees         = if ($null -eq $_.PSObject.Properties['inPersonAttendees']) { $null } elseif ($null -eq $_.inPersonAttendees) { 0 } else { [int]$_.inPersonAttendees }
        LiveStreamViews           = if ($null -eq $_.PSObject.Properties['liveStreamViews']) { $null } elseif ($null -eq $_.liveStreamViews) { 0 } else { [int]$_.liveStreamViews }
        SubscriberBase            = if ($null -eq $_.PSObject.Properties['subscriberBase']) { $null } elseif ($null -eq $_.subscriberBase) { 0 } else { [int]$_.subscriberBase }
        NumberOfSessions          = if ($null -eq $_.PSObject.Properties['numberOfSessions']) { $null } elseif ($null -eq $_.numberOfSessions) { 0 } else { [int]$_.numberOfSessions }
        NumberOfViews             = if ($null -eq $_.PSObject.Properties['numberOfViews']) { $null } elseif ($null -eq $_.numberOfViews) { 0 } else { [int]$_.numberOfViews }
        OnDemandViews             = if ($null -eq $_.PSObject.Properties['onDemandViews']) { $null } elseif ($null -eq $_.onDemandViews) { 0 } else { [int]$_.onDemandViews }
        Date                      = $startDate
        EndDate                   = $endDate
    }
} | Where-Object {
    -not [string]::IsNullOrWhiteSpace($_.Title) -and
    -not [string]::IsNullOrWhiteSpace($_.Description) -and (
        ($UpdateExisting -and $null -ne $_.Id -and $_.Id -gt 0) -or (
            -not $UpdateExisting -and
            -not [string]::IsNullOrWhiteSpace($_.Url) -and
            -not [string]::IsNullOrWhiteSpace($_.TechnologyFocusArea)
        )
    )
}

Write-Host "Loaded $($selectedActivities.Count) activities from $ActivitiesJsonPath"

if ($selectedActivities.Count -eq 0) {
    Write-Host 'No activities to submit.'
    return
}

if ($WhatIfPreference) {
    Write-Host 'WhatIf: skipping MVP authentication.'
    $previewAction = if ($UpdateExisting) { 'Would update existing activity' } else { 'Would add activity' }
    foreach ($candidate in $selectedActivities) {
        Write-Host "$previewAction`: $($candidate.Title)"
    }
    return
}

Connect-Mvp -UseDefaultBrowser:$UseDefaultBrowser -Force:($ForceReconnect -or $UpdateExisting)

function Get-MvpValidateSetValues {
    param(
        [Parameter(Mandatory)][string]$ParameterName
    )

    $parameter = (Get-Command -Name New-MvpActivity).Parameters[$ParameterName]
    $validateSet = $parameter.Attributes | Where-Object { $_ -is [System.Management.Automation.ValidateSetAttribute] } | Select-Object -First 1
    if ($null -eq $validateSet) {
        return @()
    }

    $staticValues = @($validateSet.ValidValues) | Where-Object { -not [string]::IsNullOrWhiteSpace([string]$_) }
    if ($staticValues.Count -gt 0) {
        return $staticValues
    }

    if ($null -eq $validateSet.ValidValuesGeneratorType) {
        return @()
    }

    $generator = [Activator]::CreateInstance($validateSet.ValidValuesGeneratorType)
    return @($generator.GetValidValues()) | Where-Object { -not [string]::IsNullOrWhiteSpace([string]$_) }
}

$technologyAreaValidValues = @(Get-MvpValidateSetValues -ParameterName 'TechnologyFocusArea')
$additionalTechValidValues = @(Get-MvpValidateSetValues -ParameterName 'AdditionalTechnologyAreas')

function Set-MvpActivityFieldsFromCandidate {
    param(
        [Parameter(Mandatory)]$Activity,
        [Parameter(Mandatory)]$Candidate
    )

    $Activity.description = $Candidate.Description
    if (-not [string]::IsNullOrWhiteSpace($Candidate.Url)) {
        $Activity.url = $Candidate.Url
    }
    if ($null -ne $Candidate.Quantity) {
        $Activity.quantity = $Candidate.Quantity
    }
    if ($null -ne $Candidate.Reach) {
        $Activity.reach = $Candidate.Reach
    }
    if ($null -ne $Candidate.InPersonAttendees) {
        $Activity.inPersonAttendees = $Candidate.InPersonAttendees
    }
    if ($null -ne $Candidate.LiveStreamViews) {
        $Activity.liveStreamViews = $Candidate.LiveStreamViews
    }
    if ($null -ne $Candidate.SubscriberBase) {
        $Activity.subscriberBase = $Candidate.SubscriberBase
    }
    if ($null -ne $Candidate.NumberOfSessions) {
        $Activity.numberOfSessions = $Candidate.NumberOfSessions
    }
    if ($null -ne $Candidate.NumberOfViews) {
        $Activity.numberOfViews = $Candidate.NumberOfViews
    }
    if ($null -ne $Candidate.OnDemandViews) {
        $Activity.onDemandViews = $Candidate.OnDemandViews
    }

    if ($Candidate.HasPrivateDescription) {
        $Activity.privateDescription = $Candidate.PrivateDescription
    }
    if (-not [string]::IsNullOrWhiteSpace($Candidate.Role)) {
        $Activity.role = $Candidate.Role
    }
    if (-not [string]::IsNullOrWhiteSpace($Candidate.ContributionRoleLocKey)) {
        $Activity.contributionRoleLocKey = $Candidate.ContributionRoleLocKey
    }

    return $Activity
}

if ($UpdateExisting -and @($selectedActivities | Where-Object { $null -eq $_.Id -or $_.Id -lt 1 }).Count -eq 0) {
    foreach ($candidate in $selectedActivities) {
        if ($PSCmdlet.ShouldProcess($candidate.Title, 'Update existing MVP activity')) {
            $rawActivity = Invoke-MvpRestMethod -Endpoint "Activities/$($candidate.Id)" -Method 'GET'
            $rawActivity = Set-MvpActivityFieldsFromCandidate -Activity $rawActivity -Candidate $candidate
            $response = Invoke-MvpRestMethod -Endpoint 'Activities' -Body @{ activity = $rawActivity } -Method 'PUT'
            $updatedId = if ($null -ne $response.PSObject.Properties['id'] -and $response.id) { $response.id } else { $candidate.Id }
            Write-Host "Updated activity: $($candidate.Title) (Id: $updatedId)"
        }
    }

    return
}

$existingActivities = @()

try {
    $existingActivities = Search-MvpActivitySummary -First 10000 -ErrorAction Stop | ForEach-Object {
        $title = if ($null -ne $_.PSObject.Properties['title']) { [string]$_.title } elseif ($null -ne $_.PSObject.Properties['activityTitle']) { [string]$_.activityTitle } else { '' }
        $url = if ($null -ne $_.PSObject.Properties['url']) { [string]$_.url } elseif ($null -ne $_.PSObject.Properties['activityUrl']) { [string]$_.activityUrl } elseif ($null -ne $_.PSObject.Properties['link']) { [string]$_.link } else { '' }

        [pscustomobject]@{
            id    = [int]$_.id
            title = $title
            url   = $url
        }
    }
}
catch {
    Write-Warning "Search-MvpActivitySummary failed ($($_.Exception.Message)). Duplicate check will be skipped for this run."
    $existingActivities = @()
}

foreach ($candidate in $selectedActivities) {
    if (-not [string]::IsNullOrWhiteSpace($candidate.TechnologyFocusArea) -and $technologyAreaValidValues.Count -gt 0 -and $candidate.TechnologyFocusArea -notin $technologyAreaValidValues) {
        throw "Unsupported TechnologyFocusArea for '$($candidate.Title)': $($candidate.TechnologyFocusArea)"
    }

    $isDuplicate = $existingActivities | Where-Object {
        $_.url -eq $candidate.Url -or $_.title -eq $candidate.Title
    }

    if ($isDuplicate) {
        if (-not $UpdateExisting) {
            Write-Host "Skipping existing activity: $($candidate.Title)"
            continue
        }

        $existingActivity = $isDuplicate | Select-Object -First 1
        if ($null -eq $existingActivity.PSObject.Properties['id'] -or $existingActivity.id -lt 1) {
            Write-Warning "Skipping update for '$($candidate.Title)' because duplicate detection did not return an activity id."
            continue
        }

        if ($PSCmdlet.ShouldProcess($candidate.Title, 'Update existing MVP activity')) {
            $rawActivity = Invoke-MvpRestMethod -Endpoint "Activities/$($existingActivity.id)" -Method 'GET'
            $rawActivity = Set-MvpActivityFieldsFromCandidate -Activity $rawActivity -Candidate $candidate
            $response = Invoke-MvpRestMethod -Endpoint 'Activities' -Body @{ activity = $rawActivity } -Method 'PUT'
            $updatedId = if ($null -ne $response.PSObject.Properties['id'] -and $response.id) { $response.id } else { $existingActivity.id }
            Write-Host "Updated activity: $($candidate.Title) (Id: $updatedId)"
        }

        continue
    }

    $additionalTechAreas = @($candidate.AdditionalTechnologyAreas)
    if ($additionalTechValidValues.Count -gt 0) {
        $invalidAdditionalAreas = $additionalTechAreas | Where-Object { $_ -and ($_ -notin $additionalTechValidValues) }
        if ($invalidAdditionalAreas.Count -gt 0) {
            Write-Warning "Ignoring unsupported AdditionalTechnologyAreas for '$($candidate.Title)': $($invalidAdditionalAreas -join ', ')"
        }

        $additionalTechAreas = $additionalTechAreas | Where-Object { $_ -and ($_ -in $additionalTechValidValues) }
    }

    $newActivityParams = @{
        Title                     = $candidate.Title
        Description               = $candidate.Description
        Type                      = $candidate.Type
        TechnologyFocusArea       = $candidate.TechnologyFocusArea
        TargetAudience            = $candidate.TargetAudience
        Quantity                  = if ($null -eq $candidate.Quantity) { 1 } else { $candidate.Quantity }
        Reach                     = if ($null -eq $candidate.Reach) { 0 } else { $candidate.Reach }
    }

    if ($null -ne $additionalTechAreas -and @($additionalTechAreas).Count -gt 0) {
        $newActivityParams.AdditionalTechnologyAreas = @($additionalTechAreas)
    }

    if ($null -ne $candidate.PSObject.Properties['Date'] -and $null -ne $candidate.Date) {
        $newActivityParams.Date = $candidate.Date
    }

    if ($null -ne $candidate.PSObject.Properties['EndDate'] -and $null -ne $candidate.EndDate) {
        $newActivityParams.EndDate = $candidate.EndDate
    }

    $newMvpActivity = New-MvpActivity @newActivityParams

    $newMvpActivity = Set-MvpActivityFieldsFromCandidate -Activity $newMvpActivity -Candidate $candidate

    if ($PSCmdlet.ShouldProcess($candidate.Title, 'Add MVP activity')) {
        try {
            $response = Invoke-MvpRestMethod -Endpoint 'Activities' -Body @{ activity = $newMvpActivity } -Method 'POST'
            $createdId = if ($null -ne $response.PSObject.Properties['contributionId'] -and $response.contributionId) { $response.contributionId } elseif ($null -ne $response.PSObject.Properties['id'] -and $response.id) { $response.id } else { 'unknown' }

            Write-Host "Added activity: $($candidate.Title) (Id: $createdId)"
        }
        catch {
            $message = $_.Exception.Message
            $isKnownCastIssue = $message -match 'Cannot convert value' -or $message -match 'to type "MvpActivity"'

            if (-not $isKnownCastIssue) {
                throw
            }

            Write-Warning "Direct API create completed but the module failed while reading the created activity for '$($candidate.Title)'."
        }
    }
}
