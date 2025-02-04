CREATE TABLE [dbo].[AdtnlIntMHUnitAdtnlInt] (
    [AdditionalInterestId]     INT           NOT NULL,
    [UnitAdditionalInterestId] INT           NOT NULL,
    [PolicyId]                 INT           NOT NULL,
    [PolicyNbr]                VARCHAR (16)  NOT NULL,
    [UpdatedTmstmp]            DATETIME2 (7) NOT NULL,
    [UserUpdatedId]            CHAR (8)      NOT NULL,
    [LastActionCd]             CHAR (1)      NOT NULL,
    [SourceSystemCd]           CHAR (2)      NOT NULL,
    CONSTRAINT [PK_AdtnlIntMHUnitAdtnlInt] PRIMARY KEY NONCLUSTERED ([AdditionalInterestId] ASC, [UnitAdditionalInterestId] ASC) ON [POLICYCD],
    CONSTRAINT [FK_AdditionalInterestMHUnitAdditonalInterest_AdditionalInterest_01] FOREIGN KEY ([AdditionalInterestId]) REFERENCES [dbo].[AdditionalInterest] ([AdditionalInterestId]),
    CONSTRAINT [FK_AdditionalInterestMHUnitAdditonalInterest_MobileHomeUnitAdditionalInterest_01] FOREIGN KEY ([UnitAdditionalInterestId]) REFERENCES [dbo].[MobileHomeUnitAdditionalInterest] ([UnitAdditionalInterestId])
) ON [POLICYCD];

