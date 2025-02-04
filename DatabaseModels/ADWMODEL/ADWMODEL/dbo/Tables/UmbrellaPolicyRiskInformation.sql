CREATE TABLE [dbo].[UmbrellaPolicyRiskInformation] (
    [PolicyId]           INT            NOT NULL,
    [RateFieldNm]        VARCHAR (50)   NOT NULL,
    [PolicyNbr]          VARCHAR (16)   NOT NULL,
    [RateFieldCnt]       INT            NULL,
    [PremiumAmt]         DECIMAL (9, 2) NULL,
    [ProratedPremiumAmt] DECIMAL (9, 2) NULL,
    [CreatedTmstmp]      DATETIME       NOT NULL,
    [UserCreatedId]      CHAR (8)       NOT NULL,
    [UpdatedTmstmp]      DATETIME2 (7)  NOT NULL,
    [LastActionCd]       CHAR (1)       NOT NULL,
    [SourceSystemCd]     CHAR (2)       NOT NULL,
    CONSTRAINT [PK_UmbrellaPolicyRiskInformation] PRIMARY KEY CLUSTERED ([PolicyId] ASC, [RateFieldNm] ASC) ON [POLICYCD],
    CONSTRAINT [FK_UmbrellaPolicyRiskInformation_UmbrellaPolicy_01] FOREIGN KEY ([PolicyId]) REFERENCES [dbo].[UmbrellaPolicy] ([PolicyId])
) ON [POLICYCD];


GO
CREATE NONCLUSTERED INDEX [IX_UmbrellaPolicyRiskInformation_01]
    ON [dbo].[UmbrellaPolicyRiskInformation]([PolicyId] ASC)
    ON [POLICYCI];

