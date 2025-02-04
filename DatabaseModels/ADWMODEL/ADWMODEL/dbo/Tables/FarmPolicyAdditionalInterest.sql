﻿CREATE TABLE [dbo].[FarmPolicyAdditionalInterest] (
    [PolicyId]                 INT           NOT NULL,
    [FarmPolicyAdditionalId]   INT           NOT NULL,
    [PolicyNbr]                VARCHAR (16)  NOT NULL,
    [MortgageeSequenceNbr]     CHAR (3)      NULL,
    [MortgageeLoanNbr]         CHAR (35)     NULL,
    [PCAdditionalInterestNbr]  CHAR (10)     NULL,
    [InterestDesc]             VARCHAR (255) NULL,
    [ToTheAttentionOfNm]       VARCHAR (50)  NULL,
    [EscrowInd]                CHAR (1)      NULL,
    [TempAdditionalInterestId] INT           NULL,
    [ActiveMortgageeInd]       BIT           NOT NULL,
    [CreatedTmstmp]            DATETIME      NOT NULL,
    [UserCreatedId]            CHAR (8)      NOT NULL,
    [UpdatedTmstmp]            DATETIME2 (7) NOT NULL,
    [UserUpdatedId]            CHAR (8)      NOT NULL,
    [LastActionCd]             CHAR (1)      NOT NULL,
    [SourceSystemCd]           CHAR (2)      NOT NULL,
    CONSTRAINT [PK_FarmPolicyAdditionalInterest] PRIMARY KEY CLUSTERED ([PolicyId] ASC, [FarmPolicyAdditionalId] ASC) ON [POLICYCD],
    CONSTRAINT [FK_FarmPolicyAdditionalInterest_FarmPolicy_01] FOREIGN KEY ([PolicyId]) REFERENCES [dbo].[FarmPolicy] ([PolicyId])
) ON [POLICYCD];


GO
CREATE NONCLUSTERED INDEX [IX_FarmPolicyAdditionalInterest_01]
    ON [dbo].[FarmPolicyAdditionalInterest]([PolicyId] ASC)
    ON [POLICYCI];

