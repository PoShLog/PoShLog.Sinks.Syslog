function Add-SinkSyslogLocal {
	<#
	.SYNOPSIS
		Writes log events to syslog server
	.DESCRIPTION
		Writes log events to syslog server
	.PARAMETER LoggerConfig
		Instance of LoggerConfiguration
	.PARAMETER AppName
		The name of the application. Defaults to the current process name
	.PARAMETER Facility
		The category of the application
	.PARAMETER OutputTemplate
		A message template describing the format used to write to the sink.
	.PARAMETER RestrictedToMinimumLevel
		The minimum level for events passed through the sink. Ignored when LevelSwitch is specified.
	.INPUTS
		Instance of LoggerConfiguration
	.OUTPUTS
		LoggerConfiguration object allowing method chaining
	.EXAMPLE
		PS> Add-SinkSyslogTcp -Hostname 'syslogServer1'
	#>

	[Cmdletbinding()]
	param(
		[Parameter(Mandatory = $true, ValueFromPipeline = $true)]
		[Serilog.LoggerConfiguration]$LoggerConfig,

		[Parameter(Mandatory = $false)]
		[string]$AppName = $null,

		[Parameter(Mandatory = $false)]
		[Serilog.Sinks.Syslog.Facility]$Facility = [Serilog.Sinks.Syslog.Facility]::Local0,

		[Parameter(Mandatory = $false)]
		[string]$OutputTemplate = '{Message}{NewLine}{Exception}{ErrorRecord}',

		[Parameter(Mandatory = $false)]
		[Serilog.Events.LogEventLevel]$RestrictedToMinimumLevel = [Serilog.Events.LogEventLevel]::Verbose
	)

	process {	
		$LoggerConfig = [Serilog.SyslogLoggerConfigurationExtensions]::LocalSyslog($LoggerConfig.WriteTo,
			$AppName,
			$Facility,
			$OutputTemplate,
			$RestrictedToMinimumLevel
		)

		$LoggerConfig
	}
}