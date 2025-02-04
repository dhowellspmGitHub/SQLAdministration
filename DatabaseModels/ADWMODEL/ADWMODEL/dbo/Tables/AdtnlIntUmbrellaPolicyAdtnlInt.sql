CREATE TABLE [dbo].[AdtnlIntUmbrellaPolicyAdtnlInt] (
    [AdditionalInterestId]               INT           NOT NULL,
    [UmbrellaPolicyAdditionalInterestId] INT           NOT NULL,
    [PolicyId]                           INT           NOT NULL,
    [PolicyNbr]                          VARCHAR (16)  NOT NULL,
    [UpdatedTmstmp]                      DATETIME2 (7) NOT NULL,
    [UserUpdatedId]                      CHAR (8)      NOT NULL,
    [LastActionCd]                       CHAR (1)      NOT NULL,
    [SourceSystemCd]                     CHAR (2)      NOT NULL,
    CONSTRAINT [PK_AdtnlIntUmbrellaPolicyAdtnlInt] PRIMARY KEY CLUSTERED ([AdditionalInterestId] ASC, [UmbrellaPolicyAdditionalInterestId] ASC, [PolicyId] ASC) ON [POLICYCD],
    CONSTRAINT [FK_AdditionalInterestUmbrellaPolicyAdditonalInterest_AdditionalInterest_01] FOREIGN KEY ([AdditionalInterestId]) REFERENCES [dbo].[AdditionalInterest] ([AdditionalInterestId]),
    CONSTRAINT [FK_AdditionalInterestUmbrellaUnitAdditionalInterest_UmbrellaUnitAdditionalInterest_01] FOREIGN KEY ([UmbrellaPolicyAdditionalInterestId], [PolicyId]) REFERENCES [dbo].[UmbrellaPolicyAdditionalInterest] ([UmbrellaPolicyAdditionalInterestId], [PolicyId])
) ON [POLICYCD];


GO
CREATE NONCLUSTERED INDEX [IX_AdtnlIntUmbrellaPolicyAdtnlInt_01]
    ON [dbo].[AdtnlIntUmbrellaPolicyAdtnlInt]([PolicyId] ASC)
    ON [POLICYCI];

