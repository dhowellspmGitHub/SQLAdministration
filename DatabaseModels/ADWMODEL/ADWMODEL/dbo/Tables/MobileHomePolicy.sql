CREATE TABLE [dbo].[MobileHomePolicy] (
    [PolicyId]                    INT            NOT NULL,
    [PolicyNbr]                   VARCHAR (16)   NOT NULL,
    [ActiveAutoPolicyDiscountInd] CHAR (1)       NULL,
    [AlInsuranceCreditScoreCd]    CHAR (2)       NULL,
    [ReinsuranceCategoryCd]       CHAR (2)       NULL,
    [ComputerRatedLevelCd]        CHAR (1)       NULL,
    [MineSubsidenceCoverageCd]    CHAR (1)       NULL,
    [CurrentCustomerInd]          CHAR (1)       NULL,
    [ClaimScoreCnt]               INT            NULL,
    [SurchargeExemptInd]          CHAR (1)       NULL,
    [PropertyCreditScoreFctr]     DECIMAL (4, 3) NULL,
    [LossesSinceLapseCountCnt]    INT            NULL,
    [PicturesSubmittedInd]        CHAR (1)       NULL,
    [ActiveAutoFctr]              DECIMAL (4, 3) NULL,
    [ClaimScoreDt]                DATE           NULL,
    [UpdatedTmstmp]               DATETIME2 (7)  NOT NULL,
    [UserUpdatedId]               CHAR (8)       NOT NULL,
    [LastActionCd]                CHAR (1)       NOT NULL,
    [SourceSystemCd]              CHAR (2)       NOT NULL,
    CONSTRAINT [PK_MobileHomePolicy] PRIMARY KEY CLUSTERED ([PolicyId] ASC) ON [POLICYCD],
    CONSTRAINT [FK_MobileHomePolicy_Policy_01] FOREIGN KEY ([PolicyId]) REFERENCES [dbo].[Policy] ([PolicyId])
) ON [POLICYCD];


GO
CREATE NONCLUSTERED INDEX [IX_MobileHomePolicy_01]
    ON [dbo].[MobileHomePolicy]([PolicyId] ASC)
    ON [POLICYCI];

