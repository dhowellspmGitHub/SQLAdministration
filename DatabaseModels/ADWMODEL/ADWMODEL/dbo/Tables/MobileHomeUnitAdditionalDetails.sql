CREATE TABLE [dbo].[MobileHomeUnitAdditionalDetails] (
    [MobileHomeUnitAdditionalDetailsId] INT           NOT NULL,
    [UnitNbr]                           INT           NOT NULL,
    [PolicyId]                          INT           NOT NULL,
    [ItemNbr]                           CHAR (3)      NOT NULL,
    [PolicyNbr]                         VARCHAR (16)  NOT NULL,
    [ItemDesc]                          VARCHAR (150) NULL,
    [CoverageCd]                        CHAR (3)      NULL,
    [CoverageLimitAmt]                  DECIMAL (9)   NULL,
    [MineSubsidenceInd]                 CHAR (1)      NULL,
    [UpdatedTmstmp]                     DATETIME2 (7) NOT NULL,
    [UserUpdatedId]                     CHAR (8)      NOT NULL,
    [LastActionCd]                      CHAR (1)      NOT NULL,
    [SourceSystemCd]                    CHAR (2)      NOT NULL,
    CONSTRAINT [PK_MobileHomeUnitAdditionalDetails] PRIMARY KEY CLUSTERED ([MobileHomeUnitAdditionalDetailsId] ASC) ON [POLICYCD],
    CONSTRAINT [FK_MobileHomeUnitAdditionalDetails_MobileHomeUnit_01] FOREIGN KEY ([PolicyId], [UnitNbr]) REFERENCES [dbo].[MobileHomeUnit] ([PolicyId], [UnitNbr])
) ON [POLICYCD];


GO
CREATE NONCLUSTERED INDEX [IX_MobileHomeUnitAdditionalDetails_01]
    ON [dbo].[MobileHomeUnitAdditionalDetails]([PolicyId] ASC)
    ON [POLICYCI];

