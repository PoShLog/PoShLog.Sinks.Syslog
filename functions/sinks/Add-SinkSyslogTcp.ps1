function Add-SinkSyslogTcp {
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
	.PARAMETER FramingType
		How to frame/delimit syslog messages for the wire
	.PARAMETER Format
		The syslog message format to be used
	.PARAMETER Facility
		The category of the application
	.PARAMETER SecureProtocols
		SSL/TLS protocols to be used for a secure channel. Set to None for an unsecured connection
	.PARAMETER CertProvider
		Optionally used to present the syslog server with a client certificate
	.PARAMETER CertValidationCallback
		Optional callback used to validate the syslog server's certificate. If null, the system default will be used
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

		[Parameter(Mandatory = $true)]
		[string]$Hostname,

		[Parameter(Mandatory = $false)]
		[int]$Port = 1468,

		[Parameter(Mandatory = $false)]
		[string]$AppName = $null,

		[Parameter(Mandatory = $false)]
		[Serilog.Sinks.Syslog.FramingType]$FramingType = [Serilog.Sinks.Syslog.FramingType]::OCTET_COUNTING,

		[Parameter(Mandatory = $false)]
		[Serilog.Sinks.Syslog.SyslogFormat]$Format = [Serilog.Sinks.Syslog.SyslogFormat]::RFC5424,

		[Parameter(Mandatory = $false)]
		[Serilog.Sinks.Syslog.Facility]$Facility = [Serilog.Sinks.Syslog.Facility]::Local0,

		[Parameter(Mandatory = $false)]
		[System.Security.Authentication.SslProtocols]$SecureProtocols = [System.Security.Authentication.SslProtocols]::Tls12,

		[Parameter(Mandatory = $false)]
		[Serilog.Sinks.Syslog.ICertificateProvider]$CertProvider = $null,

		[Parameter(Mandatory = $false)]
		[System.Net.Security.RemoteCertificateValidationCallback]$CertValidationCallback = $null,

		[Parameter(Mandatory = $false)]
		[string]$OutputTemplate = '{Message}{NewLine}{Exception}{ErrorRecord}',

		[Parameter(Mandatory = $false)]
		[Serilog.Events.LogEventLevel]$RestrictedToMinimumLevel = [Serilog.Events.LogEventLevel]::Verbose
	)

	process {	
		$LoggerConfig = [Serilog.SyslogLoggerConfigurationExtensions]::TcpSyslog($LoggerConfig.WriteTo,
			$Hostname,
			$Port,
			$AppName,
			$FramingType,
			$Format,
			$Facility,
			$SecureProtocols,
			$CertProvider,
			$CertValidationCallback,
			$OutputTemplate,
			$RestrictedToMinimumLevel
		)

		$LoggerConfig
	}
}