CREATE TABLE [dbo].[CommercialPolicyAdditionalInterest] (
    [CommercialPolicyAdditionalId] INT           NOT NULL,
    [PolicyId]                     INT           NULL,
    [PolicyNbr]                    VARCHAR (16)  NOT NULL,
    [MortgageeSequenceNbr]         CHAR (3)      NULL,
    [MortgageeLoanNbr]             CHAR (35)     NULL,
    [PCAdditionalInterestNbr]      CHAR (10)     NULL,
    [InterestDesc]                 VARCHAR (255) NULL,
    [ToTheAttentionOfNm]           VARCHAR (50)  NULL,
    [EscrowInd]                    CHAR (1)      NULL,
    [TempAdditionalInterestId]     INT           NULL,
    [ActiveMortgageeInd]           BIT           NULL,
    [EquipmentSerialNbr]           CHAR (20)     NULL,
    [LenderInd]                    CHAR (1)      NULL,
    [CreatedTmstmp]                DATETIME      NOT NULL,
    [UserCreatedId]                CHAR (8)      NOT NULL,
    [UpdatedTmstmp]                DATETIME2 (7) NOT NULL,
    [UserUpdatedId]                CHAR (8)      NOT NULL,
    [LastActionCd]                 CHAR (1)      NOT NULL,
    [SourceSystemCd]               CHAR (2)      NOT NULL,
    CONSTRAINT [PK_CommercialPolicyAdditionalInterest] PRIMARY KEY CLUSTERED ([CommercialPolicyAdditionalId] ASC) ON [POLICYCD],
    CONSTRAINT [FK_CommercialPolicyAdditionalInterest_CommercialPolicy_01] FOREIGN KEY ([PolicyId]) REFERENCES [dbo].[CommercialPolicy] ([PolicyId])
) ON [POLICYCD];


GO
CREATE NONCLUSTERED INDEX [IX_CommercialPolicyAdditionalInterest_01]
    ON [dbo].[CommercialPolicyAdditionalInterest]([PolicyId] ASC)
    ON [POLICYCI];

