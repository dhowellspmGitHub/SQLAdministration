CREATE TABLE [dbo].[AdtnlIntFarmUnitAdtnlInt] (
    [AdditionalInterestId]         INT           NOT NULL,
    [FarmUnitAdditionalInterestId] INT           NOT NULL,
    [PolicyId]                     INT           NOT NULL,
    [PolicyNbr]                    VARCHAR (16)  NOT NULL,
    [UpdatedTmstmp]                DATETIME2 (7) NOT NULL,
    [UserUpdatedId]                CHAR (8)      NOT NULL,
    [LastActionCd]                 CHAR (1)      NOT NULL,
    [SourceSystemCd]               CHAR (2)      NOT NULL,
    CONSTRAINT [PK_AdtnlIntFarmUnitAdtnlInt] PRIMARY KEY CLUSTERED ([AdditionalInterestId] ASC, [FarmUnitAdditionalInterestId] ASC) ON [POLICYCD],
    CONSTRAINT [FK_AdditionalInterestFarmUnitAdditionalInterest_AdditionalInterest_01] FOREIGN KEY ([AdditionalInterestId]) REFERENCES [dbo].[AdditionalInterest] ([AdditionalInterestId]),
    CONSTRAINT [FK_AdditionalInterestFarmUnitAdditionalInterest_FarmUnitAdditionalInterest_01] FOREIGN KEY ([FarmUnitAdditionalInterestId]) REFERENCES [dbo].[FarmUnitAdditionalInterest] ([FarmUnitAdditionalInterestId])
) ON [POLICYCD];

