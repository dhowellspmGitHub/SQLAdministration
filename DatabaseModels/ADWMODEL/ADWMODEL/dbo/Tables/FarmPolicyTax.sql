CREATE TABLE [dbo].[FarmPolicyTax] (
    [PolicyId]          INT            NOT NULL,
    [TaxTypeCd]         CHAR (3)       NOT NULL,
    [PolicyNbr]         VARCHAR (16)   NOT NULL,
    [TaxCd]             CHAR (4)       NULL,
    [TaxExemptInd]      CHAR (1)       NULL,
    [TaxJurisdictionNm] CHAR (40)      NULL,
    [TaxOverrideInd]    CHAR (1)       NULL,
    [TaxPremiumAmt]     DECIMAL (9, 2) NULL,
    [TaxRateFctr]       DECIMAL (9, 4) NULL,
    [UpdatedTmstmp]     DATETIME2 (7)  NOT NULL,
    [UserUpdatedId]     CHAR (8)       NOT NULL,
    [LastActionCd]      CHAR (1)       NOT NULL,
    [SourceSystemCd]    CHAR (2)       NOT NULL,
    CONSTRAINT [PK_FarmPolicyTax] PRIMARY KEY CLUSTERED ([PolicyId] ASC, [TaxTypeCd] ASC) ON [POLICYCD],
    CONSTRAINT [FK_FarmPolicyTax_FarmPolicy_01] FOREIGN KEY ([PolicyId]) REFERENCES [dbo].[FarmPolicy] ([PolicyId])
) ON [POLICYCD];


GO
CREATE NONCLUSTERED INDEX [IX_FarmPolicyTax_01]
    ON [dbo].[FarmPolicyTax]([PolicyId] ASC)
    ON [POLICYCI];

