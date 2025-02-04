CREATE TABLE [dbo].[FirePolicy] (
    [PolicyId]                    INT           NOT NULL,
    [PolicyNbr]                   VARCHAR (16)  NOT NULL,
    [ComputerRatedLevelCd]        CHAR (1)      NULL,
    [CurrentCustomerInd]          CHAR (1)      NULL,
    [SurchargeExemptInd]          CHAR (1)      NULL,
    [ActiveAutoPolicyDiscountInd] CHAR (1)      NULL,
    [PolicyTypeCd]                CHAR (1)      NULL,
    [ExtraFarmsNbr]               INT           NULL,
    [ExtraMortgageesInd]          CHAR (1)      NULL,
    [EQAddDt]                     DATE          NULL,
    [EQRemoveDt]                  DATE          NULL,
    [UpdatedTmstmp]               DATETIME2 (7) NOT NULL,
    [UserUpdatedId]               CHAR (8)      NOT NULL,
    [LastActionCd]                CHAR (1)      NOT NULL,
    [SourceSystemCd]              CHAR (2)      NOT NULL,
    CONSTRAINT [PK_FirePolicy] PRIMARY KEY CLUSTERED ([PolicyId] ASC) ON [POLICYCD],
    CONSTRAINT [FK_FirePolicy_Policy_01] FOREIGN KEY ([PolicyId]) REFERENCES [dbo].[Policy] ([PolicyId])
) ON [POLICYCD];

