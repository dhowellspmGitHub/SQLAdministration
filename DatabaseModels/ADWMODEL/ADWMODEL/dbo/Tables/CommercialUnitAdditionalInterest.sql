CREATE TABLE [dbo].[CommercialUnitAdditionalInterest] (
    [UnitAdditionalInterestId] INT           NOT NULL,
    [AdditionalInterestId]     INT           NOT NULL,
    [PolicyId]                 INT           NOT NULL,
    [UnitNbr]                  INT           NOT NULL,
    [PolicyNbr]                VARCHAR (16)  NOT NULL,
    [ActiveMortgageeInd]       BIT           NOT NULL,
    [MortgageeSequenceNbr]     CHAR (1)      NULL,
    [MortgageeLoanNbr]         CHAR (15)     NULL,
    [InterestDesc]             CHAR (30)     NULL,
    [ToTheAttentionOfNm]       VARCHAR (50)  NULL,
    [EscrowInd]                CHAR (1)      NULL,
    [UpdatedTmstmp]            DATETIME2 (7) NOT NULL,
    [UserUpdatedId]            CHAR (8)      NOT NULL,
    [LastActionCd]             CHAR (1)      NOT NULL,
    [SourceSystemCd]           CHAR (2)      NOT NULL,
    CONSTRAINT [PK_CommercialUnitAdditionalInterest] PRIMARY KEY CLUSTERED ([UnitAdditionalInterestId] ASC, [AdditionalInterestId] ASC) ON [POLICYCD],
    CONSTRAINT [FK_CommercialUnitAdditionalInterest_AdditionalInterest_01] FOREIGN KEY ([AdditionalInterestId]) REFERENCES [dbo].[AdditionalInterest] ([AdditionalInterestId]),
    CONSTRAINT [FK_CommercialUnitAdditionalInterest_CommercialUnit_01] FOREIGN KEY ([PolicyId], [UnitNbr]) REFERENCES [dbo].[CommercialUnit] ([PolicyId], [UnitNbr])
) ON [POLICYCD];


GO
CREATE NONCLUSTERED INDEX [IX_CommercialUnitAdditionalInterest_02]
    ON [dbo].[CommercialUnitAdditionalInterest]([PolicyId] ASC)
    ON [POLICYCI];


GO
CREATE NONCLUSTERED INDEX [IX_CommercialUnitAdditionalInterest_01]
    ON [dbo].[CommercialUnitAdditionalInterest]([PolicyId] ASC)
    ON [POLICYCI];

