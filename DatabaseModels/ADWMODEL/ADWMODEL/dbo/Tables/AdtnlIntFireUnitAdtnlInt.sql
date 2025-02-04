CREATE TABLE [dbo].[AdtnlIntFireUnitAdtnlInt] (
    [AdditionalInterestId]         INT           NOT NULL,
    [FireUnitAdditionalInterestId] INT           NOT NULL,
    [PolicyId]                     INT           NOT NULL,
    [PolicyNbr]                    VARCHAR (16)  NOT NULL,
    [UpdatedTmstmp]                DATETIME2 (7) NOT NULL,
    [UserUpdatedId]                CHAR (8)      NOT NULL,
    [LastActionCd]                 CHAR (1)      NOT NULL,
    [SourceSystemCd]               CHAR (2)      NOT NULL,
    CONSTRAINT [PK_AdtnlIntFireUnitAdtnlInt] PRIMARY KEY NONCLUSTERED ([FireUnitAdditionalInterestId] ASC, [AdditionalInterestId] ASC) ON [POLICYCD],
    CONSTRAINT [FK_AdditionalInterestFireUnitAdditonalInterest_AdditionalInterest_01] FOREIGN KEY ([AdditionalInterestId]) REFERENCES [dbo].[AdditionalInterest] ([AdditionalInterestId]),
    CONSTRAINT [FK_AdditionalInterestFireUnitAdditonalInterest_FireUnitAdditionalInterest_01] FOREIGN KEY ([FireUnitAdditionalInterestId]) REFERENCES [dbo].[FireUnitAdditionalInterest] ([FireUnitAdditionalInterestId])
) ON [POLICYCD];

