CREATE TABLE [dbo].[AdtnlIntHomeUnitAdtnlInt] (
    [AdditionalInterestId]     INT           NOT NULL,
    [UnitAdditionalInterestId] INT           NOT NULL,
    [PolicyId]                 INT           NOT NULL,
    [PolicyNbr]                VARCHAR (16)  NOT NULL,
    [UpdatedTmstmp]            DATETIME2 (7) NOT NULL,
    [UserUpdatedId]            CHAR (8)      NOT NULL,
    [LastActionCd]             CHAR (1)      NOT NULL,
    [SourceSystemCd]           CHAR (2)      NOT NULL,
    CONSTRAINT [PK_AdtnlIntHomeUnitAdtnlInt] PRIMARY KEY NONCLUSTERED ([AdditionalInterestId] ASC, [UnitAdditionalInterestId] ASC) ON [POLICYCD],
    CONSTRAINT [FK_AdditionalInterestHomeUnitAdditonalInterest_AdditionalInterest_01] FOREIGN KEY ([AdditionalInterestId]) REFERENCES [dbo].[AdditionalInterest] ([AdditionalInterestId]),
    CONSTRAINT [FK_AdditionalInterestHomeUnitAdditonalInterest_HomeUnitAdditionalInterest_01] FOREIGN KEY ([UnitAdditionalInterestId]) REFERENCES [dbo].[HomeUnitAdditionalInterest] ([UnitAdditionalInterestId])
) ON [POLICYCD];

