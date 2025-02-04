CREATE TABLE [dbo].[CommercialBuildingUnitAdditionalInterest] (
    [CommercialBuildingUnitAdditionalInterestId] INT           NOT NULL,
    [PolicyId]                                   INT           NULL,
    [UnitNbr]                                    INT           NULL,
    [PolicyNbr]                                  VARCHAR (16)  NOT NULL,
    [MortgageeSequenceNbr]                       CHAR (3)      NULL,
    [MortgageeLoanNbr]                           CHAR (35)     NULL,
    [PCAdditionalInterestNbr]                    CHAR (10)     NULL,
    [InterestDesc]                               VARCHAR (255) NULL,
    [ToTheAttentionOfNm]                         VARCHAR (50)  NULL,
    [EscrowInd]                                  CHAR (1)      NULL,
    [CreatedTmstmp]                              DATETIME      NOT NULL,
    [UserCreatedId]                              CHAR (8)      NOT NULL,
    [UpdatedTmstmp]                              DATETIME2 (7) NOT NULL,
    [UserUpdatedId]                              CHAR (8)      NOT NULL,
    [LastActionCd]                               CHAR (1)      NOT NULL,
    [SourceSystemCd]                             CHAR (2)      NOT NULL,
    CONSTRAINT [PK_CommercialBuildingUnitAdditionalInterest] PRIMARY KEY CLUSTERED ([CommercialBuildingUnitAdditionalInterestId] ASC) ON [POLICYCD],
    CONSTRAINT [FK_CommercialBuildingUnitAdditionalInterest_CommercialBuildingUnit_01] FOREIGN KEY ([PolicyId], [UnitNbr]) REFERENCES [dbo].[CommercialBuildingUnit] ([PolicyId], [UnitNbr])
) ON [POLICYCD];


GO
CREATE NONCLUSTERED INDEX [IX_CommercialBuildingUnitAdditionalInterest_01]
    ON [dbo].[CommercialBuildingUnitAdditionalInterest]([PolicyId] ASC)
    ON [POLICYCI];

