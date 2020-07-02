function Add-SinkSyslog {
	<#
	.SYNOPSIS
		Writes log events to syslog server
	.DESCRIPTION
		Writes log events to syslog server
	.PARAMETER LoggerConfig
		Instance of LoggerConfiguration
	.PARAMETER Hostname
		Hostname of the syslog server
	.PARAMETER Port
		Port the syslog server is listening on
	.PARAMETER AppName
		The name of the application. Defaults to the current process name
	.PARAMETER Format
		The syslog message format to be used
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
		PS> Add-SinkSyslog -Hostname 'syslogServer1'
	#>

	[Cmdletbinding()]
	param(
		[Parameter(Mandatory = $true, ValueFromPipeline = $true)]
		[Serilog.LoggerConfiguration]$LoggerConfig,
		[Parameter(Mandatory = $true)]
		[string]$Hostname,
		[Parameter(Mandatory = $false)]
		[int]$Port = 514,
		[Parameter(Mandatory = $false)]
		[string]$AppName = $null,
		[Parameter(Mandatory = $false)]
		[Serilog.Sinks.Syslog.SyslogFormat]$Format = [Serilog.Sinks.Syslog.SyslogFormat]::RFC3164,
		[Parameter(Mandatory = $false)]
		[Serilog.Sinks.Syslog.Facility]$Facility = [Serilog.Sinks.Syslog.Facility]::Local0,
		[Parameter(Mandatory = $false)]
		[string]$OutputTemplate = '{Message}{NewLine}{Exception}{ErrorRecord}',
		[Parameter(Mandatory = $false)]
		[Serilog.Events.LogEventLevel]$RestrictedToMinimumLevel = [Serilog.Events.LogEventLevel]::Verbose
	)

	process {	
		$LoggerConfig = [Serilog.SyslogLoggerConfigurationExtensions]::UdpSyslog($LoggerConfig.WriteTo,
			$Hostname,
			$Port,
			$AppName,
			$Format,
			$Facility,
			$OutputTemplate,
			$RestrictedToMinimumLevel
		)

		$LoggerConfig
	}
}