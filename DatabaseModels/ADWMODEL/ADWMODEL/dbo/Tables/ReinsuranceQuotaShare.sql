CREATE TABLE [dbo].[ReinsuranceQuotaShare] (
    [QSReinsuranceCd]          VARCHAR (2)    NULL,
    [ReinsuranceEffectiveDate] DATE           NULL,
    [ReinsuranceExpirationDt]  DATE           NULL,
    [QSReinsurancePct]         DECIMAL (5, 4) NULL
) ON [CLAIMSCD];

